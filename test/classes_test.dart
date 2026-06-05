import 'package:test/test.dart';
import 'helpers.dart';

void main() {
  group('Classes - basic', () {
    test('instantiate class and read field set in constructor', () async {
      final result = await run('''
        class Point {
          x;
          y;
          function constructor(x, y) {
            this.x = x;
            this.y = y;
          }
        }
        function main() {
          p = new Point(3, 7);
          return p.x;
        }
      ''');
      expect(result, 3);
    });

    test('call method on instance', () async {
      final result = await run('''
        class Counter {
          value;
          function constructor(v) {
            this.value = v;
          }
          function increment() {
            this.value = this.value + 1;
            return this.value;
          }
        }
        function main() {
          c = new Counter(10);
          return c.increment();
        }
      ''');
      expect(result, 11);
    });

    test('undeclared field defaults to null', () async {
      final result = await run('''
        class Box {
          item;
        }
        function main() {
          b = new Box();
          return b.item;
        }
      ''');
      expect(result, null);
    });

    test('assign to field after instantiation', () async {
      final result = await run('''
        class Box {
          item;
        }
        function main() {
          b = new Box();
          b.item = "hello";
          return b.item;
        }
      ''');
      expect(result, 'hello');
    });

    test('class with no fields or constructor', () async {
      final result = await run('''
        class Empty {
          function greet() {
            return "hi";
          }
        }
        function main() {
          e = new Empty();
          return e.greet();
        }
      ''');
      expect(result, 'hi');
    });
  });

  group('Classes - inheritance', () {
    test('child inherits parent method', () async {
      final result = await run('''
        class Animal {
          name;
          function constructor(name) {
            this.name = name;
          }
          function speak() {
            return this.name + " makes a sound";
          }
        }
        class Dog extends Animal {
          function constructor(name) {
            super(name);
          }
        }
        function main() {
          d = new Dog("Rex");
          return d.speak();
        }
      ''');
      expect(result, 'Rex makes a sound');
    });

    test('child overrides parent method', () async {
      final result = await run('''
        class Animal {
          name;
          function constructor(name) {
            this.name = name;
          }
          function speak() {
            return "generic sound";
          }
        }
        class Dog extends Animal {
          function constructor(name) {
            super(name);
          }
          function speak() {
            return "Woof!";
          }
        }
        function main() {
          d = new Dog("Rex");
          return d.speak();
        }
      ''');
      expect(result, 'Woof!');
    });

    test('super() calls parent constructor and sets fields', () async {
      final result = await run('''
        class Animal {
          name;
          function constructor(name) {
            this.name = name;
          }
        }
        class Dog extends Animal {
          function constructor(name) {
            super(name);
          }
        }
        function main() {
          d = new Dog("Buddy");
          return d.name;
        }
      ''');
      expect(result, 'Buddy');
    });

    test('super.method() calls parent version of overridden method', () async {
      final result = await run('''
        class Animal {
          name;
          function constructor(name) {
            this.name = name;
          }
          function speak() {
            return this.name + " says something";
          }
        }
        class Dog extends Animal {
          function constructor(name) {
            super(name);
          }
          function speak() {
            return super.speak() + " - woof!";
          }
        }
        function main() {
          d = new Dog("Rex");
          return d.speak();
        }
      ''');
      expect(result, 'Rex says something - woof!');
    });

    test('multi-level inheritance method lookup', () async {
      final result = await run('''
        class A {
          function hello() {
            return "A";
          }
        }
        class B extends A {
        }
        class C extends B {
        }
        function main() {
          c = new C();
          return c.hello();
        }
      ''');
      expect(result, 'A');
    });

    test('multi-level super chain calls all constructors', () async {
      final result = await run('''
        class GrandParent {
          base;
          function constructor() {
            this.base = "gp";
          }
        }
        class Parent extends GrandParent {
          function constructor() {
            super();
          }
        }
        class Child extends Parent {
          function constructor() {
            super();
          }
        }
        function main() {
          c = new Child();
          return c.base;
        }
      ''');
      expect(result, 'gp');
    });
  });

  group('Classes - interfaces', () {
    test('class implementing interface successfully instantiates', () async {
      final result = await run('''
        interface Greetable {
          function greet();
        }
        class Person implements Greetable {
          name;
          function constructor(name) {
            this.name = name;
          }
          function greet() {
            return "Hello, " + this.name;
          }
        }
        function main() {
          p = new Person("Alice");
          return p.greet();
        }
      ''');
      expect(result, 'Hello, Alice');
    });

    test('class missing interface method throws at construction', () async {
      expect(
        () async => await run('''
          interface Drawable {
            function draw();
          }
          class Square implements Drawable {
          }
          function main() {
            s = new Square();
            return "ok";
          }
        '''),
        throwsException,
      );
    });

    test('parent method satisfies interface requirement in child', () async {
      final result = await run('''
        interface Movable {
          function move();
        }
        class Base {
          function move() {
            return "moving";
          }
        }
        class Child extends Base implements Movable {
        }
        function main() {
          c = new Child();
          return c.move();
        }
      ''');
      expect(result, 'moving');
    });

    test('class implements multiple interfaces', () async {
      final result = await run('''
        interface Flyable {
          function fly();
        }
        interface Swimmable {
          function swim();
        }
        class Duck implements Flyable, Swimmable {
          function fly() {
            return "flying";
          }
          function swim() {
            return "swimming";
          }
        }
        function main() {
          d = new Duck();
          return d.fly() + " and " + d.swim();
        }
      ''');
      expect(result, 'flying and swimming');
    });
  });
}
