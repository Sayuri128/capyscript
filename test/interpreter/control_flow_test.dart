import 'package:test/test.dart';
import '../helpers.dart';

void main() {
  group('If / else', () {
    test('if branch taken when condition is true', () async {
      expect(
        await run('''
          function main() {
            if(true) { return 1; }
            return 0;
          }
        '''),
        equals(1),
      );
    });

    test('if branch skipped when condition is false', () async {
      expect(
        await run('''
          function main() {
            if(false) { return 1; }
            return 0;
          }
        '''),
        equals(0),
      );
    });

    test('else branch taken when condition is false', () async {
      expect(
        await run('''
          function main() {
            if(false) { return 1; } else { return 2; }
          }
        '''),
        equals(2),
      );
    });

    test('else if chain - first branch', () async {
      expect(
        await run('''
          function main() {
            x = 1;
            if(x == 1) { return "one"; }
            else if(x == 2) { return "two"; }
            else { return "other"; }
          }
        '''),
        equals('one'),
      );
    });

    test('else if chain - middle branch', () async {
      expect(
        await run('''
          function main() {
            x = 2;
            if(x == 1) { return "one"; }
            else if(x == 2) { return "two"; }
            else { return "other"; }
          }
        '''),
        equals('two'),
      );
    });

    test('else if chain - else branch', () async {
      expect(
        await run('''
          function main() {
            x = 99;
            if(x == 1) { return "one"; }
            else if(x == 2) { return "two"; }
            else { return "other"; }
          }
        '''),
        equals('other'),
      );
    });

    test('condition using comparison operator', () async {
      expect(
        await run('''
          function main() {
            x = 10;
            if(x > 5) { return "big"; }
            return "small";
          }
        '''),
        equals('big'),
      );
    });

    test('nested if', () async {
      expect(
        await run('''
          function main() {
            a = true;
            b = true;
            if(a) {
              if(b) { return "both"; }
              return "a only";
            }
            return "neither";
          }
        '''),
        equals('both'),
      );
    });
  });

  group('For loop', () {
    test('basic counting loop', () async {
      expect(
        await run('''
          function main() {
            sum = 0;
            for(i = 0; i < 5; i = i + 1) {
              sum = sum + i;
            }
            return sum;
          }
        '''),
        equals(10),
      );
    });

    test('loop variable is accessible after loop', () async {
      expect(
        await run('''
          function main() {
            for(i = 0; i < 3; i = i + 1) {}
            return i;
          }
        '''),
        equals(3),
      );
    });

    test('loop that never executes', () async {
      expect(
        await run('''
          function main() {
            count = 0;
            for(i = 0; i < 0; i = i + 1) {
              count = count + 1;
            }
            return count;
          }
        '''),
        equals(0),
      );
    });

    test('loop with decrement', () async {
      expect(
        await run('''
          function main() {
            sum = 0;
            for(i = 3; i > 0; i = i - 1) {
              sum = sum + i;
            }
            return sum;
          }
        '''),
        equals(6),
      );
    });

    test('nested loops', () async {
      expect(
        await run('''
          function main() {
            count = 0;
            for(i = 0; i < 3; i = i + 1) {
              for(j = 0; j < 3; j = j + 1) {
                count = count + 1;
              }
            }
            return count;
          }
        '''),
        equals(9),
      );
    });
  });

  group('Break', () {
    test('break exits loop early', () async {
      expect(
        await run('''
          function main() {
            count = 0;
            for(i = 0; i < 10; i = i + 1) {
              if(i == 3) { break; }
              count = count + 1;
            }
            return count;
          }
        '''),
        equals(3),
      );
    });

    test('break only exits innermost loop', () async {
      expect(
        await run('''
          function main() {
            outer = 0;
            for(i = 0; i < 3; i = i + 1) {
              for(j = 0; j < 10; j = j + 1) {
                if(j == 2) { break; }
              }
              outer = outer + 1;
            }
            return outer;
          }
        '''),
        equals(3),
      );
    });
  });

  group('Continue', () {
    test('continue skips rest of body (increment inside body)', () async {
      // increment is placed before continue to avoid infinite loop
      expect(
        await run('''
          function main() {
            sum = 0;
            i = 0;
            for(; i < 5;) {
              i = i + 1;
              if(i == 3) { continue; }
              sum = sum + i;
            }
            return sum;
          }
        '''),
        equals(12),
      );
    });
  });
}
