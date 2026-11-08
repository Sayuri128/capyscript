import 'package:test/test.dart';
import '../helpers.dart';

void main() {
  group('Logical not', () {
    test('negates booleans', () async {
      expect(await run('function main() { return !true; }'), isFalse);
      expect(await run('function main() { a = false; return !a; }'), isTrue);
    });

    test('treats null and zero as falsy like && and ||', () async {
      expect(await run('function main() { return !null; }'), isTrue);
      expect(await run('function main() { return !0; }'), isTrue);
      expect(await run('function main() { return !"text"; }'), isFalse);
    });

    test('binds tighter than comparison and works in conditions', () async {
      expect(
        await run('''
          function main() {
            l = [];
            if (!l.isNotEmpty && !(1 > 2)) { return "empty"; }
            return "full";
          }
        '''),
        equals('empty'),
      );
    });

    test('still lexes != as not-equal', () async {
      expect(await run('function main() { return 1 != 2; }'), isTrue);
    });
  });

  group('Compound assignment', () {
    test('updates variables', () async {
      expect(
        await run('''
          function main() {
            a = 10;
            a += 5;
            a -= 3;
            a *= 2;
            a /= 4;
            return a;
          }
        '''),
        equals(6),
      );
    });

    test('concatenates strings', () async {
      expect(
        await run('''
          function main() {
            s = "a";
            s += "b";
            return s;
          }
        '''),
        equals('ab'),
      );
    });

    test('updates map entries and properties', () async {
      expect(
        await run('''
          function main() {
            m = {"n": 1};
            m["n"] += 2;
            return m["n"];
          }
        '''),
        equals(3),
      );
    });

    test('updates captured variables from a lambda', () async {
      expect(
        await run('''
          function main() {
            total = 0;
            l = [1, 2, 3];
            l.forEach(function(x) { total += x; });
            return total;
          }
        '''),
        equals(6),
      );
    });
  });

  group('while', () {
    test('loops until the condition is false', () async {
      expect(
        await run('''
          function main() {
            n = 0;
            while (n < 5) { n += 1; }
            return n;
          }
        '''),
        equals(5),
      );
    });

    test('supports break and continue', () async {
      expect(
        await run('''
          function main() {
            n = 0;
            odd = 0;
            while (true) {
              n += 1;
              if (n > 9) { break; }
              if (n % 2 == 0) { continue; }
              odd += 1;
            }
            return odd;
          }
        '''),
        equals(5),
      );
    });
  });

  group('for', () {
    test('an empty condition loops until break', () async {
      expect(
        await run('''
          function main() {
            for (i = 0; ; i++) {
              if (i == 3) { break; }
            }
            return i;
          }
        '''),
        equals(3),
      );
    });

    test('for-in iterates list elements', () async {
      expect(
        await run('''
          function main() {
            sum = 0;
            for (x in [1, 2, 3]) { sum += x; }
            return sum;
          }
        '''),
        equals(6),
      );
    });

    test('for-in iterates map keys', () async {
      expect(
        await run('''
          function main() {
            keys = [];
            for (k in {"a": 1, "b": 2}) { keys.push(k); }
            return keys;
          }
        '''),
        equals(['a', 'b']),
      );
    });

    test('for-in supports break and continue', () async {
      expect(
        await run('''
          function main() {
            out = [];
            for (x in [1, 2, 3, 4, 5]) {
              if (x == 2) { continue; }
              if (x == 4) { break; }
              out.push(x);
            }
            return out;
          }
        '''),
        equals([1, 3]),
      );
    });
  });

  group('String escapes', () {
    test('are processed in double and single quoted strings', () async {
      expect(await run(r'function main() { return "a\nb\t\"c\"\\"; }'), equals('a\nb\t"c"\\'));
      expect(await run(r"function main() { return 'it\'s'; }"), equals("it's"));
    });

    test('keep unknown sequences such as regex classes', () async {
      expect(await run(r'function main() { return "\d+\s"; }'), equals(r'\d+\s'));
    });

    test('are not processed in backtick strings', () async {
      expect(await run(r'function main() { return `a\nb`; }'), equals(r'a\nb'));
    });
  });

  group('Index statements', () {
    test('calls a method on an indexed element', () async {
      expect(
        await run('''
          function main() {
            groups = [{"elements": []}];
            groups[0].elements.push(1);
            groups[0]["elements"].push(2);
            return groups[0].elements;
          }
        '''),
        equals([1, 2]),
      );
    });
  });

  group('break', () {
    test('does not run the increment', () async {
      expect(
        await run('''
          function main() {
            for (i = 0; i < 10; i = i + 1) {
              if (i == 3) { break; }
            }
            return i;
          }
        '''),
        equals(3),
      );
    });

    test('continue still runs the increment once', () async {
      expect(
        await run('''
          function main() {
            seen = [];
            for (i = 0; i < 4; i = i + 1) {
              if (i == 1) { continue; }
              seen.push(i);
            }
            return seen;
          }
        '''),
        equals([0, 2, 3]),
      );
    });
  });
}
