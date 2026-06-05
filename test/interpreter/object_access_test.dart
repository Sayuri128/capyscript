import 'package:test/test.dart';
import '../helpers.dart';

void main() {
  group('Array index access', () {
    test('access by integer index', () async {
      expect(
        await run('function main() { arr = [10, 20, 30]; return arr[0]; }'),
        equals(10),
      );
    });

    test('access last element by index', () async {
      expect(
        await run('function main() { arr = [10, 20, 30]; return arr[2]; }'),
        equals(30),
      );
    });

    test('access using variable as index', () async {
      expect(
        await run('''
          function main() {
            arr = [10, 20, 30];
            i = 1;
            return arr[i];
          }
        '''),
        equals(20),
      );
    });
  });

  group('Map bracket access', () {
    test('access by string key', () async {
      expect(
        await run('function main() { m = {"x": 5}; return m["x"]; }'),
        equals(5),
      );
    });

    test('access using variable as key', () async {
      expect(
        await run('''
          function main() {
            m = {"name": "Alice"};
            k = "name";
            return m[k];
          }
        '''),
        equals('Alice'),
      );
    });
  });

  group('Nested access', () {
    test('nested map access', () async {
      expect(
        await run('''
          function main() {
            m = {"a": {"b": 42}};
            return m["a"]["b"];
          }
        '''),
        equals(42),
      );
    });

    test('array of maps', () async {
      expect(
        await run('''
          function main() {
            arr = [{"v": 1}, {"v": 2}];
            return arr[1]["v"];
          }
        '''),
        equals(2),
      );
    });

    test('map of arrays', () async {
      expect(
        await run('''
          function main() {
            m = {"nums": [10, 20, 30]};
            return m["nums"][2];
          }
        '''),
        equals(30),
      );
    });
  });

  group('Object set (assignment)', () {
    test('set map value via bracket', () async {
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

    test('add new key to map', () async {
      expect(
        await run('''
          function main() {
            m = {};
            m["new"] = "value";
            return m["new"];
          }
        '''),
        equals('value'),
      );
    });

    test('set nested map value', () async {
      expect(
        await run('''
          function main() {
            m = {"outer": {"inner": 0}};
            m["outer"]["inner"] = 7;
            return m["outer"]["inner"];
          }
        '''),
        equals(7),
      );
    });

    test('set array element', () async {
      expect(
        await run('''
          function main() {
            arr = [1, 2, 3];
            arr[1] = 99;
            return arr[1];
          }
        '''),
        equals(99),
      );
    });
  });
}
