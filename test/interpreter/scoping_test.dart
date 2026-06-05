import 'package:test/test.dart';
import '../helpers.dart';

void main() {
  group('Function scope isolation', () {
    test('variable set in called function does not affect caller', () async {
      expect(
        await run('''
          function setX() { x = 100; return x; }
          function main() {
            x = 42;
            setX();
            return x;
          }
        '''),
        equals(42),
      );
    });

    test('function has its own variable namespace', () async {
      expect(
        await run('''
          function compute() {
            result = 999;
            return result;
          }
          function main() {
            result = 1;
            compute();
            return result;
          }
        '''),
        equals(1),
      );
    });

    test('successive calls get fresh scopes', () async {
      expect(
        await run('''
          function counter() {
            count = 0;
            count = count + 1;
            return count;
          }
          function main() {
            a = counter();
            b = counter();
            return a + b;
          }
        '''),
        equals(2),
      );
    });
  });

  group('Block scope (no new scope for if/for)', () {
    test('variable assigned in if block is visible after', () async {
      expect(
        await run('''
          function main() {
            if(true) { y = 42; }
            return y;
          }
        '''),
        equals(42),
      );
    });

    test('variable assigned in for loop is visible after', () async {
      expect(
        await run('''
          function main() {
            for(i = 0; i < 3; i = i + 1) {
              last = i;
            }
            return last;
          }
        '''),
        equals(2),
      );
    });

    test('if block can update variable from outer scope', () async {
      expect(
        await run('''
          function main() {
            result = "initial";
            if(true) { result = "updated"; }
            return result;
          }
        '''),
        equals('updated'),
      );
    });
  });

  group('Nested function calls', () {
    test('deeply nested calls unwind scope correctly', () async {
      expect(
        await run('''
          function a() { v = 1; return v; }
          function b() { v = 2; a(); return v; }
          function main() { v = 3; b(); return v; }
        '''),
        equals(3),
      );
    });
  });
}
