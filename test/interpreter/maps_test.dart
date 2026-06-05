import 'package:test/test.dart';
import '../helpers.dart';

void main() {
  group('Map literals', () {
    test('empty map', () async {
      expect(await run('function main() { return {}; }'), equals({}));
    });

    test('string-keyed map', () async {
      final result = await run('function main() { return {"a": 1, "b": 2}; }');
      expect(result, equals({'a': 1, 'b': 2}));
    });

    test('map with mixed value types', () async {
      final result = await run(
        'function main() { return {"n": 42, "s": "hello", "b": true}; }',
      );
      expect(result, equals({'n': 42, 's': 'hello', 'b': true}));
    });
  });

  group('Map access', () {
    test('bracket access by string key', () async {
      expect(
        await run('function main() { m = {"key": 99}; return m["key"]; }'),
        equals(99),
      );
    });

    test('property-style access', () async {
      expect(
        await run('function main() { m = {"name": "Alice"}; return m.name; }'),
        equals('Alice'),
      );
    });
  });

  group('Map properties', () {
    test('isEmpty - true', () async {
      expect(await run('function main() { m = {}; return m.isEmpty; }'), isTrue);
    });

    test('isEmpty - false', () async {
      expect(
        await run('function main() { m = {"a": 1}; return m.isEmpty; }'),
        isFalse,
      );
    });

    test('isNotEmpty - true', () async {
      expect(
        await run('function main() { m = {"a": 1}; return m.isNotEmpty; }'),
        isTrue,
      );
    });

    test('keys', () async {
      final result = await run(
        'function main() { m = {"a": 1, "b": 2}; return m.keys; }',
      );
      expect(result.toList(), containsAll(['a', 'b']));
    });

    test('values', () async {
      final result = await run(
        'function main() { m = {"a": 1, "b": 2}; return m.values; }',
      );
      expect(result.toList(), containsAll([1, 2]));
    });
  });

  group('Map methods', () {
    test('containsKey - true', () async {
      expect(
        await run('function main() { m = {"a": 1}; return m.containsKey("a"); }'),
        isTrue,
      );
    });

    test('containsKey - false', () async {
      expect(
        await run('function main() { m = {"a": 1}; return m.containsKey("b"); }'),
        isFalse,
      );
    });

    test('containsValue - true', () async {
      expect(
        await run('function main() { m = {"a": 42}; return m.containsValue(42); }'),
        isTrue,
      );
    });

    test('containsValue - false', () async {
      expect(
        await run('function main() { m = {"a": 42}; return m.containsValue(99); }'),
        isFalse,
      );
    });

    test('remove deletes key', () async {
      expect(
        await run('''
          function main() {
            m = {"a": 1, "b": 2};
            m.remove("a");
            return m.containsKey("a");
          }
        '''),
        isFalse,
      );
    });

    test('clear empties the map', () async {
      expect(
        await run('''
          function main() {
            m = {"a": 1, "b": 2};
            m.clear();
            return m.isEmpty;
          }
        '''),
        isTrue,
      );
    });

    test('addAll merges maps', () async {
      final result = await run('''
        function main() {
          m = {"a": 1};
          m.addAll({"b": 2, "c": 3});
          return m;
        }
      ''');
      expect(result, equals({'a': 1, 'b': 2, 'c': 3}));
    });
  });

  group('Map mutation', () {
    test('set new key via bracket assignment', () async {
      expect(
        await run('''
          function main() {
            m = {"a": 1};
            m["b"] = 2;
            return m["b"];
          }
        '''),
        equals(2),
      );
    });

    test('update existing key', () async {
      expect(
        await run('''
          function main() {
            m = {"a": 1};
            m["a"] = 99;
            return m["a"];
          }
        '''),
        equals(99),
      );
    });

    test('nested map set', () async {
      expect(
        await run('''
          function main() {
            m = {"inner": {"x": 1}};
            m["inner"]["x"] = 42;
            return m["inner"]["x"];
          }
        '''),
        equals(42),
      );
    });
  });
}
