import 'package:capyscript/parser/parser.dart';
import 'package:test/test.dart';

void main() {
  group('Parser - function declarations', () {
    test('parses single function', () {
      final tree = Parser(source: 'function main() { return 1; }').parse();
      expect(tree.functions.length, 1);
      expect(tree.functions.first.functionName, 'main');
    });

    test('parses multiple functions', () {
      const src = '''
        function add(a, b) { return a + b; }
        function main() { return 0; }
      ''';
      final tree = Parser(source: src).parse();
      expect(tree.functions.length, 2);
      expect(tree.functions.map((f) => f.functionName), containsAll(['add', 'main']));
    });

    test('parses function with no parameters', () {
      final tree = Parser(source: 'function greet() { return "hi"; }').parse();
      expect(tree.functions.first.parameters, isEmpty);
    });

    test('parses function with parameters', () {
      final tree = Parser(source: 'function add(a, b) { return a + b; }').parse();
      expect(tree.functions.first.parameters.length, 2);
      expect(tree.functions.first.parameters.map((p) => p.paramName), ['a', 'b']);
    });
  });

  group('Parser - imports', () {
    test('parses single import', () {
      const src = '''
        import "http";
        function main() { return 1; }
      ''';
      final tree = Parser(source: src).parse();
      expect(tree.modules.length, 1);
      expect(tree.modules.first.moduleName, 'http');
    });

    test('parses multiple imports', () {
      const src = '''
        import "http";
        import "json";
        function main() { return 1; }
      ''';
      final tree = Parser(source: src).parse();
      expect(tree.modules.length, 2);
      expect(tree.modules.map((m) => m.moduleName), containsAll(['http', 'json']));
    });

    test('empty source produces empty tree', () {
      final tree = Parser(source: '').parse();
      expect(tree.functions, isEmpty);
      expect(tree.modules, isEmpty);
    });
  });

  group('Parser - errors', () {
    test('throws on incomplete function declaration', () {
      expect(() => Parser(source: 'function').parse(), throwsException);
    });

    test('throws on missing function name', () {
      expect(() => Parser(source: 'function () { }').parse(), throwsException);
    });

    test('throws on unclosed string literal', () {
      expect(
        () => Parser(source: 'function main() { return "unclosed; }').parse(),
        throwsException,
      );
    });
  });

  group('Parser - caches result', () {
    test('calling parse twice returns same tree', () {
      final parser = Parser(source: 'function main() { return 1; }');
      final tree1 = parser.parse();
      final tree2 = parser.parse();
      expect(identical(tree1, tree2), isTrue);
    });
  });
}
