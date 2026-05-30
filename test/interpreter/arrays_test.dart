import 'package:test/test.dart';
import '../helpers.dart';

void main() {
  group('Array literals', () {
    test('empty array', () async {
      expect(await run('function main() { return []; }'), equals([]));
    });

    test('integer array', () async {
      expect(
        await run('function main() { return [1, 2, 3]; }'),
        equals([1, 2, 3]),
      );
    });

    test('mixed type array', () async {
      final result = await run('function main() { return [1, "two", true]; }');
      expect(result, equals([1, 'two', true]));
    });

    test('nested array', () async {
      final result = await run('function main() { return [[1, 2], [3, 4]]; }');
      expect(result, equals([[1, 2], [3, 4]]));
    });
  });

  group('Array concatenation', () {
    test('concatenates two arrays with +', () async {
      expect(
        await run('function main() { return [1, 2] + [3, 4]; }'),
        equals([1, 2, 3, 4]),
      );
    });
  });

  group('Array properties', () {
    test('length', () async {
      expect(
        await run('function main() { arr = [1, 2, 3]; return arr.length; }'),
        equals(3),
      );
    });

    test('isEmpty - true', () async {
      expect(await run('function main() { arr = []; return arr.isEmpty; }'), isTrue);
    });

    test('isEmpty - false', () async {
      expect(await run('function main() { arr = [1]; return arr.isEmpty; }'), isFalse);
    });

    test('isNotEmpty - true', () async {
      expect(await run('function main() { arr = [1]; return arr.isNotEmpty; }'), isTrue);
    });

    test('first', () async {
      expect(
        await run('function main() { arr = [10, 20, 30]; return arr.first; }'),
        equals(10),
      );
    });

    test('last', () async {
      expect(
        await run('function main() { arr = [10, 20, 30]; return arr.last; }'),
        equals(30),
      );
    });
  });

  group('Array methods', () {
    test('push adds element to end', () async {
      expect(
        await run('''
          function main() {
            arr = [1, 2];
            arr.push(3);
            return arr;
          }
        '''),
        equals([1, 2, 3]),
      );
    });

    test('push multiple elements', () async {
      expect(
        await run('''
          function main() {
            arr = [1];
            arr.push(2, 3);
            return arr;
          }
        '''),
        equals([1, 2, 3]),
      );
    });

    test('pop removes and returns last element', () async {
      expect(
        await run('''
          function main() {
            arr = [1, 2, 3];
            return arr.pop();
          }
        '''),
        equals(3),
      );
    });

    test('pop mutates the array', () async {
      expect(
        await run('''
          function main() {
            arr = [1, 2, 3];
            arr.pop();
            return arr.length;
          }
        '''),
        equals(2),
      );
    });

    test('elementAt', () async {
      expect(
        await run('''
          function main() {
            arr = [10, 20, 30];
            return arr.elementAt(1);
          }
        '''),
        equals(20),
      );
    });

    test('removeAt removes element at index', () async {
      expect(
        await run('''
          function main() {
            arr = [1, 2, 3];
            arr.removeAt(1);
            return arr;
          }
        '''),
        equals([1, 3]),
      );
    });

    test('removeAt returns removed element', () async {
      expect(
        await run('''
          function main() {
            arr = [10, 20, 30];
            return arr.removeAt(0);
          }
        '''),
        equals(10),
      );
    });
  });

  group('Array index access', () {
    test('access by index', () async {
      expect(
        await run('function main() { arr = [10, 20, 30]; return arr[1]; }'),
        equals(20),
      );
    });

    test('access first element', () async {
      expect(
        await run('function main() { arr = ["a", "b"]; return arr[0]; }'),
        equals('a'),
      );
    });
  });
}
