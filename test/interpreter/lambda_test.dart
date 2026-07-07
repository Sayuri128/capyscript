import 'package:test/test.dart';
import '../helpers.dart';

void main() {
  group('Lambdas', () {
    test('lambda stored in a variable and called', () async {
      expect(
        await run('''
          function main() {
            var add = function(a, b) { return a + b; };
            return add(3, 4);
          }
        '''),
        equals(7),
      );
    });

    test('lambda captures surrounding variables (closure)', () async {
      expect(
        await run('''
          function main() {
            var factor = 10;
            var scale = function(x) { return x * factor; };
            return scale(5);
          }
        '''),
        equals(50),
      );
    });

    test('lambda passed to a function parameter', () async {
      expect(
        await run('''
          function apply(f, v) { return f(v); }
          function main() { return apply(function(x) { return x + 1; }, 41); }
        '''),
        equals(42),
      );
    });

    test('lambda with default parameter', () async {
      expect(
        await run('''
          function main() {
            var f = function(x, y = 10) { return x + y; };
            return f(5);
          }
        '''),
        equals(15),
      );
    });
  });

  group('Higher-order list methods', () {
    test('map', () async {
      expect(
        await run(
            'function main() { return [1,2,3].map(function(x) { return x * 2; }); }'),
        equals([2, 4, 6]),
      );
    });

    test('filter', () async {
      expect(
        await run(
            'function main() { return [1,2,3,4].filter(function(x) { return x % 2 == 0; }); }'),
        equals([2, 4]),
      );
    });

    test('where is an alias of filter', () async {
      expect(
        await run(
            'function main() { return [1,2,3,4].where(function(x) { return x > 2; }); }'),
        equals([3, 4]),
      );
    });

    test('reduce', () async {
      expect(
        await run(
            'function main() { return [1,2,3,4].reduce(function(a, b) { return a + b; }); }'),
        equals(10),
      );
    });

    test('fold with initial value', () async {
      expect(
        await run(
            'function main() { return [1,2,3].fold(100, function(a, b) { return a + b; }); }'),
        equals(106),
      );
    });

    test('any', () async {
      expect(
        await run(
            'function main() { return [1,2,3].any(function(x) { return x > 2; }); }'),
        isTrue,
      );
    });

    test('every', () async {
      expect(
        await run(
            'function main() { return [1,2,3].every(function(x) { return x > 0; }); }'),
        isTrue,
      );
    });

    test('map argument must be a function', () async {
      expect(
        run('function main() { return [1,2,3].map(5); }'),
        throwsA(anything),
      );
    });
  });
}
