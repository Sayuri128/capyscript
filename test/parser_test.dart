import 'package:capyscript/AST/class/ast_class_declaration_node.dart';
import 'package:capyscript/AST/class/ast_interface_declaration_node.dart';
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

  group('Parser - class declarations', () {
    Parser _parse(String src) {
      final p = Parser(source: src);
      p.parse();
      return p;
    }

    test('parses minimal class with no members', () {
      final p = _parse('class Foo { }');
      expect(p.parsedClasses.length, 1);
      expect(p.parsedClasses.first.className, 'Foo');
      expect(p.parsedClasses.first.parentClass, isNull);
      expect(p.parsedClasses.first.interfaces, isEmpty);
      expect(p.parsedClasses.first.fields, isEmpty);
      expect(p.parsedClasses.first.methods, isEmpty);
    });

    test('parses class fields', () {
      final p = _parse('class Point { x; y; }');
      final cls = p.parsedClasses.first;
      expect(cls.fields, ['x', 'y']);
    });

    test('parses class methods', () {
      final p = _parse('class Foo { function bar() { return 1; } }');
      final cls = p.parsedClasses.first;
      expect(cls.methods.length, 1);
      expect(cls.methods.first.functionName, 'bar');
    });

    test('parses extends clause', () {
      final p = _parse('class Dog extends Animal { }');
      expect(p.parsedClasses.first.parentClass, 'Animal');
    });

    test('parses single implements', () {
      final p = _parse('class Dog implements Walkable { }');
      expect(p.parsedClasses.first.interfaces, ['Walkable']);
    });

    test('parses multiple implements', () {
      final p = _parse('class Duck implements Flyable, Swimmable { }');
      expect(p.parsedClasses.first.interfaces, ['Flyable', 'Swimmable']);
    });

    test('parses extends and implements together', () {
      final p = _parse('class Dog extends Animal implements Walkable, Runnable { }');
      final cls = p.parsedClasses.first;
      expect(cls.parentClass, 'Animal');
      expect(cls.interfaces, ['Walkable', 'Runnable']);
    });

    test('parses multiple classes', () {
      final p = _parse('class A { } class B { }');
      expect(p.parsedClasses.length, 2);
      expect(p.parsedClasses.map((c) => c.className), ['A', 'B']);
    });

    test('class and function at top level coexist', () {
      final p = _parse('class Foo { } function main() { return 1; }');
      final tree = p.parse();
      expect(p.parsedClasses.length, 1);
      expect(tree.functions.length, 1);
    });

    test('throws on class without closing brace', () {
      expect(() => _parse('class Foo {'), throwsException);
    });

    test('returns ASTClassDeclarationNode instances', () {
      final p = _parse('class Foo { }');
      expect(p.parsedClasses.first, isA<ASTClassDeclarationNode>());
    });
  });

  group('Parser - interface declarations', () {
    Parser _parse(String src) {
      final p = Parser(source: src);
      p.parse();
      return p;
    }

    test('parses empty interface', () {
      final p = _parse('interface IFoo { }');
      expect(p.parsedInterfaces.length, 1);
      expect(p.parsedInterfaces.first.interfaceName, 'IFoo');
      expect(p.parsedInterfaces.first.requiredMethods, isEmpty);
    });

    test('parses interface with one method', () {
      final p = _parse('interface Drawable { function draw(); }');
      expect(p.parsedInterfaces.first.requiredMethods, ['draw']);
    });

    test('parses interface with multiple methods', () {
      final p = _parse('interface Shape { function area(); function perimeter(); }');
      expect(p.parsedInterfaces.first.requiredMethods, ['area', 'perimeter']);
    });

    test('parses multiple interfaces', () {
      final p = _parse('interface A { } interface B { }');
      expect(p.parsedInterfaces.length, 2);
      expect(p.parsedInterfaces.map((i) => i.interfaceName), ['A', 'B']);
    });

    test('returns ASTInterfaceDeclarationNode instances', () {
      final p = _parse('interface IFoo { }');
      expect(p.parsedInterfaces.first, isA<ASTInterfaceDeclarationNode>());
    });
  });
}
