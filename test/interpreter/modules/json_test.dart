import 'package:test/test.dart';
import '../../helpers.dart';

void main() {
  group('json module - jsonEncode', () {
    test('encodes map to JSON string', () async {
      final result = await run('''
        import "json";
        function main() { return jsonEncode({"key": "value"}); }
      ''');
      expect(result, equals('{"key":"value"}'));
    });

    test('encodes array to JSON string', () async {
      final result = await run('''
        import "json";
        function main() { return jsonEncode([1, 2, 3]); }
      ''');
      expect(result, equals('[1,2,3]'));
    });

    test('encodes number', () async {
      final result = await run('''
        import "json";
        function main() { return jsonEncode(42); }
      ''');
      expect(result, equals('42'));
    });

    test('encodes string', () async {
      final result = await run('''
        import "json";
        function main() { return jsonEncode("hello"); }
      ''');
      expect(result, equals('"hello"'));
    });
  });

  group('json module - jsonDecode', () {
    test('decodes JSON object to map', () async {
      // Use backtick strings so double-quotes inside don't break Capyscript's lexer
      final result = await run('''
        import "json";
        function main() { return jsonDecode(`{"key": "value"}`); }
      ''');
      expect(result, equals({'key': 'value'}));
    });

    test('decodes JSON array to list', () async {
      final result = await run('''
        import "json";
        function main() { return jsonDecode("[1, 2, 3]"); }
      ''');
      expect(result, equals([1, 2, 3]));
    });

    test('decodes JSON number', () async {
      final result = await run('''
        import "json";
        function main() { return jsonDecode("42"); }
      ''');
      expect(result, equals(42));
    });
  });

  group('json module - round-trip', () {
    test('encode then decode map', () async {
      final result = await run('''
        import "json";
        function main() {
          original = {"a": 1, "b": "hello"};
          encoded = jsonEncode(original);
          return jsonDecode(encoded);
        }
      ''');
      expect(result, equals({'a': 1, 'b': 'hello'}));
    });

    test('encode then decode array', () async {
      final result = await run('''
        import "json";
        function main() {
          original = [1, true];
          encoded = jsonEncode(original);
          return jsonDecode(encoded);
        }
      ''');
      expect(result, equals([1, true]));
    });
  });
}
