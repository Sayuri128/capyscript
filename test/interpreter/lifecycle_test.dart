import 'package:capyscript/AST/ast_tree.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/Interpreter/interpreter.dart';
import 'package:capyscript/api_clients/source_error.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/abstract/native_function_node.dart';
import 'package:test/test.dart';

class _ProbeModule extends BaseModule {
  static const String module_name = "lifecycle_probe";
  static final List<String> calls = <String>[];

  _ProbeModule() : super(moduleName: module_name) {
    body = ASTTree(functions: [
      NativeFunctionNode(
        name: "probe",
        parameters: [ASTParameterNode("label", paramType: "any")],
        implementation: (arguments) async {
          calls.add(arguments["label"].toString());
          await Future<void>.delayed(const Duration(milliseconds: 5));
          return calls.length;
        },
      ).toDeclarationNode(),
    ], modules: []);
  }
}

void main() {
  setUpAll(() {
    moduleFactories[_ProbeModule.module_name] = (_) => _ProbeModule();
  });

  tearDownAll(() {
    moduleFactories.remove(_ProbeModule.module_name);
  });

  setUp(_ProbeModule.calls.clear);

  test('onInit runs once before the first call and dependencies persist',
      () async {
    final Interpreter interpreter = Interpreter(data: r'''
      import "dependencies";
      import "lifecycle_probe";
      function onInit() {
        probe("init");
        provide("settings", {"base": "https://example.com", "hits": 0});
      }
      function visit(path) {
        settings = inject("settings");
        settings["hits"] = settings["hits"] + 1;
        return settings["base"] + path + "#" + parseString(settings["hits"]);
      }
      import "converter";
    ''');

    expect(await interpreter.runFunction("visit", arguments: {"path": "/a"}),
        'https://example.com/a#1');
    expect(await interpreter.runFunction("visit", arguments: {"path": "/b"}),
        'https://example.com/b#2');
    expect(_ProbeModule.calls, ['init']);
  });

  test('scripts without onInit behave as before', () async {
    final Interpreter interpreter =
        Interpreter(data: 'function main() { return 42; }');

    expect(interpreter.hasInit, isFalse);
    expect(await interpreter.interpret(), 42);
  });

  test('concurrent first calls share one onInit and one lazy instance',
      () async {
    final Interpreter interpreter = Interpreter(data: r'''
      import "dependencies";
      import "lifecycle_probe";
      function onInit() {
        probe("init");
        provideLazy("client", function() {
          probe("client");
          return {"id": "client"};
        });
      }
      function read(label) {
        client = inject("client");
        return label + ":" + client["id"];
      }
    ''');

    final List<dynamic> results = await Future.wait([
      interpreter.runFunction("read", arguments: {"label": "a"}),
      interpreter.runFunction("read", arguments: {"label": "b"}),
      interpreter.runFunction("read", arguments: {"label": "c"}),
    ]);

    expect(results, ['a:client', 'b:client', 'c:client']);
    expect(_ProbeModule.calls, ['init', 'client']);
  });

  test('class instances keep their methods when injected later', () async {
    final Interpreter interpreter = Interpreter(data: r'''
      import "dependencies";
      class Catalog {
        prefix: string;
        function constructor(prefix: string) {
          this.prefix = prefix;
        }
        function path(slug: string): string {
          return this.prefix + "/" + slug;
        }
      }
      function onInit() {
        provide("catalog", new Catalog("/manga"));
      }
      function main() {
        return inject("catalog").path("one-piece");
      }
    ''');

    expect(await interpreter.interpret(), '/manga/one-piece');
  });

  test('a failing onInit propagates its source error and is retried',
      () async {
    final Interpreter interpreter = Interpreter(data: r'''
      import "dependencies";
      import "errors";
      import "lifecycle_probe";
      function onInit() {
        attempt = probe("init");
        if (attempt == 1) {
          throwSourceError("sourceDown", "config endpoint is down");
        }
        provide("ready", true);
      }
      function main() {
        return inject("ready");
      }
    ''');

    await expectLater(
        interpreter.runFunction("main"),
        throwsA(isA<SourceError>()
            .having((error) => error.kind, 'kind', SourceErrorKind.sourceDown)));
    expect(await interpreter.runFunction("main"), isTrue);
    expect(_ProbeModule.calls, ['init', 'init']);
  });

  test('resetLifecycle clears dependencies and runs onInit again', () async {
    final Interpreter interpreter = Interpreter(data: r'''
      import "dependencies";
      import "lifecycle_probe";
      function onInit() {
        provide("generation", probe("init"));
      }
      function main() {
        return inject("generation");
      }
    ''');

    expect(await interpreter.runFunction("main"), 1);
    expect(await interpreter.runFunction("main"), 1);
    interpreter.resetLifecycle();
    expect(await interpreter.runFunction("main"), 2);
  });

  test('passWebBrowserInterceptorController does not trigger onInit',
      () async {
    final Interpreter interpreter = Interpreter(data: r'''
      import "lifecycle_probe";
      function onInit() {
        probe("init");
      }
      function passWebBrowserInterceptorController(controller) {
        probe("controller");
      }
    ''');

    await interpreter.runFunction("passWebBrowserInterceptorController",
        arguments: {"controller": null});

    expect(_ProbeModule.calls, ['controller']);
  });

  test('inject names what is provided when a dependency is missing',
      () async {
    final Interpreter interpreter = Interpreter(data: r'''
      import "dependencies";
      function onInit() {
        provide("api", 1);
      }
      function main() {
        return inject("graph");
      }
    ''');

    await expectLater(
        interpreter.interpret(),
        throwsA(predicate((error) => error
            .toString()
            .contains('dependency "graph" is not provided (provided: api)'))));
  });

  test('isProvided, forget and provide replace entries', () async {
    final Interpreter interpreter = Interpreter(data: r'''
      import "dependencies";
      function main() {
        before = isProvided("token");
        provideLazy("token", function() { return "lazy"; });
        lazy = inject("token");
        provide("token", "fresh");
        fresh = inject("token");
        forget("token");
        return [before, lazy, fresh, isProvided("token")];
      }
    ''');

    expect(await interpreter.interpret(), [false, 'lazy', 'fresh', false]);
  });

  test('a failed lazy factory is retried on the next inject', () async {
    final Interpreter interpreter = Interpreter(data: r'''
      import "dependencies";
      import "lifecycle_probe";
      function onInit() {
        provideLazy("session", function() {
          attempt = probe("session");
          if (attempt == 1) {
            throw "login page did not load";
          }
          return "session-" + parseString(attempt);
        });
      }
      function main() {
        return inject("session");
      }
      import "converter";
    ''');

    await expectLater(interpreter.runFunction("main"), throwsA(anything));
    expect(await interpreter.runFunction("main"), 'session-2');
    expect(await interpreter.runFunction("main"), 'session-2');
  });
}
