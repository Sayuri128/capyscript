import 'package:test/test.dart';
import '../helpers.dart';

void main() {
  group('Arithmetic', () {
    test('addition of numbers', () async {
      expect(await run('function main() { return 2 + 3; }'), equals(5));
    });

    test('string concatenation', () async {
      expect(
        await run('function main() { return "hello" + " " + "world"; }'),
        equals('hello world'),
      );
    });

    test('subtraction', () async {
      expect(await run('function main() { return 10 - 4; }'), equals(6));
    });

    test('multiplication', () async {
      expect(await run('function main() { return 3 * 4; }'), equals(12));
    });

    test('division', () async {
      expect(await run('function main() { return 10 / 4; }'), equals(2.5));
    });

    test('operator precedence: * before +', () async {
      expect(await run('function main() { return 2 + 3 * 4; }'), equals(14));
    });

    test('operator precedence: * before + (multiply on left)', () async {
      expect(await run('function main() { return 2 * 3 + 1; }'), equals(7));
    });

    test('subtraction is left-associative', () async {
      expect(await run('function main() { return 10 - 3 - 2; }'), equals(5));
    });

    test('division is left-associative', () async {
      expect(await run('function main() { return 20 / 4 / 5; }'), equals(1));
    });

    test('modulo', () async {
      expect(await run('function main() { return 10 % 3; }'), equals(1));
    });

    test('modulo has same precedence as multiply', () async {
      expect(await run('function main() { return 10 % 3 * 2; }'), equals(2));
    });

    test('parentheses override precedence', () async {
      expect(await run('function main() { return (2 + 3) * 4; }'), equals(20));
    });

    test('chained addition', () async {
      expect(await run('function main() { return 1 + 2 + 3 + 4; }'), equals(10));
    });
  });

  group('Comparison', () {
    test('equal - true', () async {
      expect(await run('function main() { return 5 == 5; }'), isTrue);
    });

    test('equal - false', () async {
      expect(await run('function main() { return 5 == 6; }'), isFalse);
    });

    test('not equal - true', () async {
      expect(await run('function main() { return 5 != 6; }'), isTrue);
    });

    test('not equal - false', () async {
      expect(await run('function main() { return 5 != 5; }'), isFalse);
    });

    test('greater than - true', () async {
      expect(await run('function main() { return 5 > 3; }'), isTrue);
    });

    test('greater than - false', () async {
      expect(await run('function main() { return 3 > 5; }'), isFalse);
    });

    test('less than - true', () async {
      expect(await run('function main() { return 3 < 5; }'), isTrue);
    });

    test('less than - false', () async {
      expect(await run('function main() { return 5 < 3; }'), isFalse);
    });

    test('greater or equal - equal case', () async {
      expect(await run('function main() { return 5 >= 5; }'), isTrue);
    });

    test('greater or equal - greater case', () async {
      expect(await run('function main() { return 6 >= 5; }'), isTrue);
    });

    test('greater or equal - false case', () async {
      expect(await run('function main() { return 4 >= 5; }'), isFalse);
    });

    test('less or equal - equal case', () async {
      expect(await run('function main() { return 5 <= 5; }'), isTrue);
    });

    test('less or equal - false case', () async {
      expect(await run('function main() { return 6 <= 5; }'), isFalse);
    });
  });

  group('Logical', () {
    test('and - bare booleans', () async {
      expect(await run('function main() { var a = true; var b = false; '
          'if (a && b) { return "both"; } return "not both"; }'),
          equals('not both'));
    });

    test('or - bare booleans', () async {
      expect(await run('function main() { var a = true; var b = false; '
          'if (a || b) { return "either"; } return "neither"; }'),
          equals('either'));
    });

    test('and - both true', () async {
      expect(await run('function main() { return 1 == 1 && 2 == 2; }'), isTrue);
    });

    test('and - one false', () async {
      expect(await run('function main() { return 1 == 1 && 1 == 0; }'), isFalse);
    });

    test('or - one true', () async {
      expect(await run('function main() { return 1 == 0 || 1 == 1; }'), isTrue);
    });

    test('or - both false', () async {
      expect(await run('function main() { return 1 == 0 || 2 == 3; }'), isFalse);
    });

    test('and short-circuits on false left', () async {
      expect(await run('function main() { return 1 == 0 && 1 == 1; }'), isFalse);
    });

    test('combined and/or', () async {
      expect(
        await run('function main() { return 1 == 1 && 1 == 0 || 1 == 1; }'),
        isTrue,
      );
    });

    test('&& does not evaluate right side when left is false', () async {
      expect(
        await run('function main() { return 1 == 0 && missing(); }'),
        isFalse,
      );
    });

    test('|| does not evaluate right side when left is true', () async {
      expect(
        await run('function main() { return 1 == 1 || missing(); }'),
        isTrue,
      );
    });
  });

  group('Increment / Decrement', () {
    // Note: ++ and -- are statement-level only; `result = i++` is a parse error.
    test('++ increments variable', () async {
      expect(
        await run('function main() { i = 5; i++; return i; }'),
        equals(6),
      );
    });

    test('-- decrements variable', () async {
      expect(
        await run('function main() { i = 5; i--; return i; }'),
        equals(4),
      );
    });

    test('multiple increments', () async {
      expect(
        await run('function main() { i = 0; i++; i++; i++; return i; }'),
        equals(3),
      );
    });
  });
}
