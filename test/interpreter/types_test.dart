import 'package:test/test.dart';
import '../helpers.dart';

void main() {
  group('Type system - var declarations', () {
    test('untyped var works normally', () async {
      final result = await run('''
        function main() {
          var x = 42;
          return x;
        }
      ''');
      expect(result, 42);
    });

    test('typed var: int accepts integer', () async {
      final result = await run('''
        function main() {
          var x: int = 5;
          return x;
        }
      ''');
      expect(result, 5);
    });

    test('typed var: string accepts string', () async {
      final result = await run('''
        function main() {
          var s: string = "hello";
          return s;
        }
      ''');
      expect(result, 'hello');
    });

    test('typed var: bool accepts bool', () async {
      final result = await run('''
        function main() {
          var b: bool = true;
          return b;
        }
      ''');
      expect(result, true);
    });

    test('typed var: float accepts number', () async {
      final result = await run('''
        function main() {
          var f: float = 3.14;
          return f;
        }
      ''');
      expect(result, closeTo(3.14, 0.001));
    });

    test('typed var: int rejects string', () async {
      expect(
        () => run('''
          function main() {
            var x: int = "bad";
            return x;
          }
        '''),
        throwsA(anything),
      );
    });

    test('typed var: string rejects int', () async {
      expect(
        () => run('''
          function main() {
            var x: string = 42;
            return x;
          }
        '''),
        throwsA(anything),
      );
    });

    test('typed var: bool rejects int', () async {
      expect(
        () => run('''
          function main() {
            var x: bool = 1;
            return x;
          }
        '''),
        throwsA(anything),
      );
    });

    test('typed var: List accepts list', () async {
      final result = await run('''
        function main() {
          var items: List = [1, 2, 3];
          return items;
        }
      ''');
      expect(result, [1, 2, 3]);
    });

    test('typed var: List rejects non-list', () async {
      expect(
        () => run('''
          function main() {
            var items: List = "not a list";
            return items;
          }
        '''),
        throwsA(anything),
      );
    });

    test('any type skips enforcement', () async {
      final result = await run('''
        function main() {
          var x: any = 42;
          return x;
        }
      ''');
      expect(result, 42);
    });

    test('dynamic type skips enforcement', () async {
      final result = await run('''
        function main() {
          var x: dynamic = "hello";
          return x;
        }
      ''');
      expect(result, 'hello');
    });
  });

  group('Type system - typed function parameters', () {
    test('typed int param accepts int', () async {
      final result = await run('''
        function add(a: int, b: int): int {
          return a + b;
        }
        function main() {
          return add(2, 3);
        }
      ''');
      expect(result, 5);
    });

    test('typed int param rejects string', () async {
      expect(
        () => run('''
          function greet(name: string): void {
            return name;
          }
          function main() {
            greet(42);
          }
        '''),
        throwsA(anything),
      );
    });

    test('typed string param accepts string', () async {
      final result = await run('''
        function greet(name: string): string {
          return "hello " + name;
        }
        function main() {
          return greet("world");
        }
      ''');
      expect(result, 'hello world');
    });

    test('untyped param still works', () async {
      final result = await run('''
        function double(x) {
          return x * 2;
        }
        function main() {
          return double(5);
        }
      ''');
      expect(result, 10);
    });

    test('optional typed param uses default when omitted', () async {
      final result = await run('''
        function greet(name: string, prefix = "Hi") {
          return prefix + " " + name;
        }
        function main() {
          return greet("world");
        }
      ''');
      expect(result, 'Hi world');
    });
  });

  group('Type system - typed return types', () {
    test('correct return type passes', () async {
      final result = await run('''
        function getNum(): int {
          return 42;
        }
        function main() {
          return getNum();
        }
      ''');
      expect(result, 42);
    });

    test('wrong return type throws', () async {
      expect(
        () => run('''
          function getNum(): int {
            return "not a number";
          }
          function main() {
            return getNum();
          }
        '''),
        throwsA(anything),
      );
    });

    test('void return type does not enforce', () async {
      final result = await run('''
        function doNothing(): void {
          return 42;
        }
        function main() {
          doNothing();
          return 1;
        }
      ''');
      expect(result, 1);
    });
  });

  group('Type system - class field types', () {
    test('typed field accepts correct type', () async {
      final result = await run('''
        class Point {
          x: int;
          y: int;
          function constructor(px: int, py: int) {
            this.x = px;
            this.y = py;
          }
          function getX(): int {
            return this.x;
          }
        }
        function main() {
          var p = new Point(3, 4);
          return p.getX();
        }
      ''');
      expect(result, 3);
    });

    test('typed field rejects wrong type on assignment', () async {
      expect(
        () => run('''
          class Foo {
            count: int;
            function constructor() {
              this.count = "not int";
            }
          }
          function main() {
            new Foo();
          }
        '''),
        throwsA(anything),
      );
    });

    test('untyped field accepts any value', () async {
      final result = await run('''
        class Box {
          value;
          function constructor(v) {
            this.value = v;
          }
          function get() {
            return this.value;
          }
        }
        function main() {
          var b = new Box("anything");
          return b.get();
        }
      ''');
      expect(result, 'anything');
    });
  });

  group('Type system - class type parameters', () {
    test('class type param accepts correct instance', () async {
      final result = await run('''
        class Animal {
          name;
          function constructor(n) {
            this.name = n;
          }
          function getName() {
            return this.name;
          }
        }
        function describe(a: Animal) {
          return a.getName();
        }
        function main() {
          var a = new Animal("dog");
          return describe(a);
        }
      ''');
      expect(result, 'dog');
    });

    test('class type param accepts subclass instance', () async {
      final result = await run('''
        class Animal {
          name;
          function constructor(n) {
            this.name = n;
          }
        }
        class Dog extends Animal {
          function constructor(n) {
            super(n);
          }
          function speak() {
            return "woof";
          }
        }
        function greet(a: Animal) {
          return a.name;
        }
        function main() {
          var d = new Dog("rex");
          return greet(d);
        }
      ''');
      expect(result, 'rex');
    });

    test('class type param rejects wrong class instance', () async {
      expect(
        () => run('''
          class Cat {
            function constructor() {}
          }
          class Dog {
            function constructor() {}
          }
          function feed(c: Cat) {
            return 1;
          }
          function main() {
            var d = new Dog();
            feed(d);
          }
        '''),
        throwsA(anything),
      );
    });
  });

  group('Type system - method typed parameters and return', () {
    test('method typed param accepted', () async {
      final result = await run('''
        class Calculator {
          function add(a: int, b: int): int {
            return a + b;
          }
        }
        function main() {
          var c = new Calculator();
          return c.add(10, 20);
        }
      ''');
      expect(result, 30);
    });

    test('method typed param rejected', () async {
      expect(
        () => run('''
          class Calculator {
            function add(a: int, b: int): int {
              return a + b;
            }
          }
          function main() {
            var c = new Calculator();
            c.add("ten", 20);
          }
        '''),
        throwsA(anything),
      );
    });

    test('method wrong return type throws', () async {
      expect(
        () => run('''
          class Foo {
            function getNum(): int {
              return "not int";
            }
          }
          function main() {
            var f = new Foo();
            f.getNum();
          }
        '''),
        throwsA(anything),
      );
    });
  });
}
