import 'package:test/test.dart';
import '../helpers.dart';

void main() {
  group('Literals - numbers', () {
    test('integer', () async {
      expect(await run('function main() { return 42; }'), equals(42));
    });

    test('float', () async {
      expect(await run('function main() { return 3.14; }'), equals(3.14));
    });

    test('zero', () async {
      expect(await run('function main() { return 0; }'), equals(0));
    });

    test('negative number via unary minus', () async {
      expect(await run('function main() { return -5; }'), equals(-5));
    });
  });

  group('Literals - strings', () {
    test('double-quoted string', () async {
      expect(await run('function main() { return "hello"; }'), equals('hello'));
    });

    test('single-quoted string', () async {
      expect(await run("function main() { return 'world'; }"), equals('world'));
    });

    test('backtick string', () async {
      expect(await run('function main() { return `test`; }'), equals('test'));
    });

    test('empty string', () async {
      expect(await run('function main() { return ""; }'), equals(''));
    });

    test('string with spaces', () async {
      expect(
        await run('function main() { return "hello world"; }'),
        equals('hello world'),
      );
    });
  });

  group('Literals - booleans', () {
    test('true', () async {
      expect(await run('function main() { return true; }'), isTrue);
    });

    test('false', () async {
      expect(await run('function main() { return false; }'), isFalse);
    });
  });

  group('Literals - null', () {
    test('null literal', () async {
      expect(await run('function main() { return null; }'), isNull);
    });

    test('null equality', () async {
      expect(
        await run('function main() { x = null; return x == null; }'),
        isTrue,
      );
    });
  });
}
