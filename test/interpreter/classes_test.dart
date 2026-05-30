import 'package:test/test.dart';
import '../helpers.dart';

void main() {
  group('ASTNewNode', () {
    test('throws when class is not defined', () {
      expect(
        () async => await run('''
          function main() { x = new Undefined(); }
        '''),
        throwsException,
      );
    });

    test('new expression result can be used immediately in expression', () async {
      final result = await run('''
        class Tag {
          label;
          function constructor(l) { this.label = l; }
          function get() { return this.label; }
        }
        function main() {
          return new Tag("hello").get();
        }
      ''');
      expect(result, 'hello');
    });

    test('multiple instances have independent field state', () async {
      final result = await run('''
        class Box {
          value;
          function constructor(v) { this.value = v; }
        }
        function main() {
          a = new Box(1);
          b = new Box(2);
          a.value = 99;
          return b.value;
        }
      ''');
      expect(result, 2);
    });

    test('constructor return value is ignored; instance is always returned', () async {
      final result = await run('''
        class Foo {
          x;
          function constructor() {
            this.x = 5;
            return "ignored";
          }
        }
        function main() {
          f = new Foo();
          return f.x;
        }
      ''');
      expect(result, 5);
    });
  });

  group('ASTThisNode', () {
    test('this.field write and read within same method', () async {
      final result = await run('''
        class Acc {
          total;
          function constructor() { this.total = 0; }
          function add(n) {
            this.total = this.total + n;
            return this.total;
          }
        }
        function main() {
          a = new Acc();
          a.add(3);
          a.add(7);
          return a.total;
        }
      ''');
      expect(result, 10);
    });

    test('this is accessible in a method called from another method', () async {
      final result = await run('''
        class Foo {
          x;
          function constructor(v) { this.x = v; }
          function getX() { return this.x; }
          function doubled() { return this.getX() + this.getX(); }
        }
        function main() {
          f = new Foo(4);
          return f.doubled();
        }
      ''');
      expect(result, 8);
    });

    test('this fields survive across multiple external method calls', () async {
      final result = await run('''
        class Counter {
          n;
          function constructor() { this.n = 0; }
          function inc() { this.n = this.n + 1; }
          function get() { return this.n; }
        }
        function main() {
          c = new Counter();
          c.inc();
          c.inc();
          c.inc();
          return c.get();
        }
      ''');
      expect(result, 3);
    });
  });

  group('ASTSuperNode', () {
    test('super() with arguments reaches parent constructor', () async {
      final result = await run('''
        class Vehicle {
          speed;
          function constructor(s) { this.speed = s; }
        }
        class Car extends Vehicle {
          brand;
          function constructor(brand, speed) {
            super(speed);
            this.brand = brand;
          }
        }
        function main() {
          c = new Car("Toyota", 120);
          return c.speed;
        }
      ''');
      expect(result, 120);
    });

    test('super.method() result can be used in expression', () async {
      final result = await run('''
        class Base {
          function value() { return 10; }
        }
        class Child extends Base {
          function value() { return super.value() * 2; }
        }
        function main() {
          return new Child().value();
        }
      ''');
      expect(result, 20);
    });

    test('calling super on class without parent throws', () {
      expect(
        () async => await run('''
          class Orphan {
            function test() { super(); }
          }
          function main() {
            new Orphan().test();
          }
        '''),
        throwsException,
      );
    });
  });

  group('ASTClassDeclarationNode - field initialisation', () {
    test('all declared fields present even if not set in constructor', () async {
      final result = await run('''
        class Pair {
          first;
          second;
          function constructor(a) { this.first = a; }
        }
        function main() {
          p = new Pair("x");
          return p.second;
        }
      ''');
      expect(result, null);
    });

    test('child class fields and parent class fields both initialised', () async {
      final result = await run('''
        class A {
          x;
        }
        class B extends A {
          y;
          function constructor() {
            this.x = 1;
            this.y = 2;
          }
        }
        function main() {
          b = new B();
          return b.x + b.y;
        }
      ''');
      expect(result, 3);
    });
  });

  group('ASTInstanceNode - method dispatch', () {
    test('calling undefined method throws', () {
      expect(
        () async => await run('''
          class Foo { }
          function main() { new Foo().missing(); }
        '''),
        throwsException,
      );
    });

    test('child method shadows parent; parent instance still uses its own', () async {
      final result = await run('''
        class Animal {
          function sound() { return "..."; }
        }
        class Dog extends Animal {
          function sound() { return "woof"; }
        }
        function main() {
          a = new Animal();
          d = new Dog();
          return a.sound() + d.sound();
        }
      ''');
      expect(result, '...woof');
    });

    test('method can return another instance', () async {
      final result = await run('''
        class Node {
          value;
          next;
          function constructor(v) {
            this.value = v;
            this.next = null;
          }
          function setNext(n) { this.next = n; return this; }
        }
        function main() {
          a = new Node(1);
          b = new Node(2);
          a.setNext(b);
          return a.next.value;
        }
      ''');
      expect(result, 2);
    });
  });

  group('ASTInterfaceDeclarationNode - enforcement', () {
    test('interface with multiple methods — missing one throws', () {
      expect(
        () async => await run('''
          interface Shape {
            function area();
            function perimeter();
          }
          class Square implements Shape {
            function area() { return 0; }
          }
          function main() { new Square(); }
        '''),
        throwsException,
      );
    });

    test('interface with multiple methods — all present succeeds', () async {
      final result = await run('''
        interface Shape {
          function area();
          function perimeter();
        }
        class Square implements Shape {
          side;
          function constructor(s) { this.side = s; }
          function area() { return this.side * this.side; }
          function perimeter() { return this.side * 4; }
        }
        function main() {
          s = new Square(3);
          return s.area() + s.perimeter();
        }
      ''');
      expect(result, 21);
    });
  });
}
