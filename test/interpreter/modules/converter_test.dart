import 'package:test/test.dart';
import '../../helpers.dart';

void main() {
  group('converter module - parseInt', () {
    test('parses integer string', () async {
      expect(
        await run('''
          import "converter";
          function main() { return parseInt("42"); }
        '''),
        equals(42),
      );
    });

    test('parses negative integer string', () async {
      expect(
        await run('''
          import "converter";
          function main() { return parseInt("-7"); }
        '''),
        equals(-7),
      );
    });

    test('parses number to int', () async {
      final result = await run('''
        import "converter";
        function main() { return parseInt(100); }
      ''');
      expect(result, equals(100));
    });
  });

  group('converter module - parseString', () {
    test('converts integer to string', () async {
      expect(
        await run('''
          import "converter";
          function main() { return parseString(42); }
        '''),
        equals('42'),
      );
    });

    test('converts float to string', () async {
      expect(
        await run('''
          import "converter";
          function main() { return parseString(3.14); }
        '''),
        equals('3.14'),
      );
    });

    test('converts boolean to string', () async {
      expect(
        await run('''
          import "converter";
          function main() { return parseString(true); }
        '''),
        equals('true'),
      );
    });
  });

  group('converter module - parseDouble', () {
    test('parses float string', () async {
      expect(
        await run('''
          import "converter";
          function main() { return parseDouble("3.14"); }
        '''),
        equals(3.14),
      );
    });

    test('parses integer string as double', () async {
      expect(
        await run('''
          import "converter";
          function main() { return parseDouble("10"); }
        '''),
        equals(10.0),
      );
    });
  });
}
