import 'package:test/test.dart';
import '../helpers.dart';

void main() {
  group('Return values', () {
    test('returns numeric value', () async {
      expect(await run('function main() { return 42; }'), equals(42));
    });

    test('returns string value', () async {
      expect(await run('function main() { return "hi"; }'), equals('hi'));
    });

    test('returns null when body is empty', () async {
      expect(await run('function main() { }'), isNull);
    });

    test('early return exits function', () async {
      expect(
        await run('''
          function main() {
            return 1;
            return 2;
          }
        '''),
        equals(1),
      );
    });
  });

  group('Parameters', () {
    test('single parameter', () async {
      expect(
        await run('''
          function double(x) { return x + x; }
          function main() { return double(5); }
        '''),
        equals(10),
      );
    });

    test('multiple parameters', () async {
      expect(
        await run('''
          function add(a, b) { return a + b; }
          function main() { return add(3, 4); }
        '''),
        equals(7),
      );
    });

    test('string parameter', () async {
      expect(
        await run('''
          function greet(name) { return "hello " + name; }
          function main() { return greet("world"); }
        '''),
        equals('hello world'),
      );
    });

    test('parameter passed as expression result', () async {
      expect(
        await run('''
          function square(n) { return n * n; }
          function main() { return square(2 + 3); }
        '''),
        equals(25),
      );
    });
  });

  group('Recursion', () {
    test('factorial', () async {
      expect(
        await run('''
          function factorial(n) {
            if(n <= 1) { return 1; }
            return n * factorial(n - 1);
          }
          function main() { return factorial(5); }
        '''),
        equals(120),
      );
    });

    test('fibonacci', () async {
      expect(
        await run('''
          function fib(n) {
            if(n <= 1) { return n; }
            return fib(n - 1) + fib(n - 2);
          }
          function main() { return fib(7); }
        '''),
        equals(13),
      );
    });
  });

  group('Function calling functions', () {
    test('function calls helper function', () async {
      expect(
        await run('''
          function square(n) { return n * n; }
          function sumOfSquares(a, b) { return square(a) + square(b); }
          function main() { return sumOfSquares(3, 4); }
        '''),
        equals(25),
      );
    });

    test('function defined after caller is still callable', () async {
      expect(
        await run('''
          function main() { return helper(); }
          function helper() { return 99; }
        '''),
        equals(99),
      );
    });
  });
}
