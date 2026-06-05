import 'package:test/test.dart';
import '../helpers.dart';

void main() {
  group('String properties', () {
    test('length', () async {
      expect(
        await run('function main() { return "hello".length; }'),
        equals(5),
      );
    });

    test('isEmpty - true', () async {
      expect(
        await run('function main() { return "".isEmpty; }'),
        isTrue,
      );
    });

    test('isEmpty - false', () async {
      expect(
        await run('function main() { return "hi".isEmpty; }'),
        isFalse,
      );
    });

    test('isNotEmpty - true', () async {
      expect(
        await run('function main() { return "hi".isNotEmpty; }'),
        isTrue,
      );
    });

    test('isNotEmpty - false', () async {
      expect(
        await run('function main() { return "".isNotEmpty; }'),
        isFalse,
      );
    });
  });

  group('String methods - search', () {
    test('contains - true', () async {
      expect(
        await run('function main() { return "hello world".contains("world"); }'),
        isTrue,
      );
    });

    test('contains - false', () async {
      expect(
        await run('function main() { return "hello".contains("xyz"); }'),
        isFalse,
      );
    });

    test('split', () async {
      final result = await run('function main() { return "a,b,c".split(","); }');
      expect(result, equals(['a', 'b', 'c']));
    });

    test('split by empty string', () async {
      final result = await run('function main() { return "abc".split(""); }');
      expect(result, equals(['a', 'b', 'c']));
    });
  });

  group('String methods - case', () {
    test('toLowerCase', () async {
      expect(
        await run('function main() { return "HELLO".toLowerCase(); }'),
        equals('hello'),
      );
    });

    test('toUpperCase', () async {
      expect(
        await run('function main() { return "hello".toUpperCase(); }'),
        equals('HELLO'),
      );
    });
  });

  group('String methods - whitespace', () {
    test('trim', () async {
      expect(
        await run('function main() { return "  hi  ".trim(); }'),
        equals('hi'),
      );
    });

    test('trimLeft', () async {
      expect(
        await run('function main() { return "  hi  ".trimLeft(); }'),
        equals('hi  '),
      );
    });

    test('trimRight', () async {
      expect(
        await run('function main() { return "  hi  ".trimRight(); }'),
        equals('  hi'),
      );
    });
  });

  group('String methods - replace', () {
    test('replaceAll', () async {
      expect(
        await run('function main() { return "aabbaa".replaceAll("a", "x"); }'),
        equals('xxbbxx'),
      );
    });

    test('replaceFirst', () async {
      expect(
        await run('function main() { return "aabbaa".replaceFirst("a", "x"); }'),
        equals('xabbaa'),
      );
    });
  });

  group('String methods - substring', () {
    test('substring with start and end', () async {
      expect(
        await run('function main() { return "hello world".substring(6, 11); }'),
        equals('world'),
      );
    });

    test('substring from start', () async {
      expect(
        await run('function main() { return "hello".substring(0, 3); }'),
        equals('hel'),
      );
    });
  });

  group('String concatenation', () {
    test('concatenates two strings', () async {
      expect(
        await run('function main() { a = "foo"; b = "bar"; return a + b; }'),
        equals('foobar'),
      );
    });

    test('concatenates number to string', () async {
      expect(
        await run('function main() { return "value: " + "42"; }'),
        equals('value: 42'),
      );
    });
  });
}
