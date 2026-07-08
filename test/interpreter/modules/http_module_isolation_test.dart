import 'package:capyscript/Interpreter/interpreter.dart';
import 'package:capyscript/modules/http/http_module.dart';
import 'package:test/test.dart';

const String _publisher = '''
import "http";

function main() {
    useHeaders({"headers": {"user-agent": "Mozilla/5.0 (Linux; Android 13)"}});
    return getHeaders();
}
''';

const String _reader = '''
import "http";

function main() { return getHeaders(); }
''';

void main() {
  group('http module state is per-interpreter', () {
    test('useHeaders in one interpreter does not leak into another', () async {
      final publisher = Interpreter(data: _publisher);
      final reader = Interpreter(data: _reader);

      expect(await reader.interpret(), isEmpty);

      final published = await publisher.interpret() as Map;
      expect(published, containsPair('user-agent', anything));

      expect(await reader.interpret(), isEmpty);
    });

    test('each interpreter owns a distinct HttpModule instance', () {
      final a = Interpreter(data: _reader);
      final b = Interpreter(data: _reader);

      final moduleA = a.builtinModule(HttpModule.module_name);
      final moduleB = b.builtinModule(HttpModule.module_name);

      expect(moduleA, isA<HttpModule>());
      expect(moduleB, isA<HttpModule>());
      expect(identical(moduleA, moduleB), isFalse);
    });

    test('builtinModule returns a stable instance within one interpreter', () {
      final interpreter = Interpreter(data: _reader);

      expect(
        identical(
          interpreter.builtinModule(HttpModule.module_name),
          interpreter.builtinModule(HttpModule.module_name),
        ),
        isTrue,
      );
    });

    test('unknown builtin module resolves to null', () {
      expect(Interpreter(data: _reader).builtinModule('not_a_module'), isNull);
    });

    test('the module instance backing imports is the one builtinModule exposes',
        () async {
      final interpreter = Interpreter(data: _publisher);
      await interpreter.interpret();

      final module =
          interpreter.builtinModule(HttpModule.module_name) as HttpModule;
      expect(module.getHeaders(), containsPair('user-agent', anything));
    });
  });
}
