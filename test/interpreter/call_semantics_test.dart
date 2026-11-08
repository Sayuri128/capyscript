import 'package:capyscript/Interpreter/capyscript_runtime_error.dart';
import 'package:capyscript/Interpreter/interpreter.dart';
import 'package:test/test.dart';
import '../helpers.dart';

void main() {
  group('Argument evaluation', () {
    test('arguments are evaluated in the caller scope', () async {
      expect(
        await run('''
          function sub(a, b) { return a - b; }
          function main() {
            a = 1;
            b = 2;
            return sub(b, a);
          }
        '''),
        equals(1),
      );
    });

    test('named arguments read caller variables that share a parameter name', () async {
      expect(
        await run('''
          function pair(uid, title) { return uid + ":" + title; }
          function main() {
            uid = "caller";
            return pair({"uid": "x", "title": uid});
          }
        '''),
        equals('x:caller'),
      );
    });

    test('arguments are evaluated left to right', () async {
      expect(
        await run('''
          function id(x) { return x; }
          function main() {
            l = [];
            l.push(id(1), id(2), id(3));
            return l;
          }
        '''),
        equals([1, 2, 3]),
      );
    });

    test('an error inside an argument expression is not replaced by the default', () async {
      expect(
        () => run('''
          function f(a = 5) { return a; }
          function main() { return f(missing); }
        '''),
        throwsA(predicate((e) => e.toString().contains('Variable missing not found'))),
      );
    });

    test('a missing required argument names the parameter', () async {
      expect(
        () => run('''
          function f(a, b) { return a; }
          function main() { return f(1); }
        '''),
        throwsA(predicate((e) => e.toString().contains('argument 2 (b) is not defined in function f'))),
      );
    });

    test('missing optional arguments fall back to defaults', () async {
      expect(
        await run('''
          function f(a, b = 10) { return a + b; }
          function main() { return f(1); }
        '''),
        equals(11),
      );
    });
  });

  group('Lexical scoping', () {
    test('a callee cannot read the caller locals', () async {
      expect(
        () => run('''
          function readSecret() { return secret; }
          function main() {
            secret = 42;
            return readSecret();
          }
        '''),
        throwsA(predicate((e) => e.toString().contains('Variable secret not found'))),
      );
    });

    test('a function called from a lambda does not see the lambda variables', () async {
      expect(
        () => run('''
          function peek() { return inner; }
          function main() {
            return [1].map(function(x) {
              inner = x;
              return peek();
            });
          }
        '''),
        throwsA(predicate((e) => e.toString().contains('Variable inner not found'))),
      );
    });
  });

  group('Closures', () {
    test('a lambda can update a captured variable', () async {
      expect(
        await run('''
          function main() {
            sum = 0;
            l = [1, 2, 3];
            l.forEach(function(x) { sum = sum + x; });
            return sum;
          }
        '''),
        equals(6),
      );
    });

    test('nested lambdas update the outermost captured variable', () async {
      expect(
        await run('''
          function main() {
            count = 0;
            rows = [[1, 2], [3]];
            rows.forEach(function(row) {
              row.forEach(function(x) { count = count + 1; });
            });
            return count;
          }
        '''),
        equals(3),
      );
    });

    test('lambda parameters shadow outer variables without overwriting them', () async {
      expect(
        await run('''
          function main() {
            x = 100;
            l = [1, 2];
            l.forEach(function(x) { x = x + 1; });
            return x;
          }
        '''),
        equals(100),
      );
    });

    test('new variables assigned in a lambda stay local to it', () async {
      expect(
        () => run('''
          function main() {
            l = [1];
            l.forEach(function(x) { fresh = x; });
            return fresh;
          }
        '''),
        throwsA(predicate((e) => e.toString().contains('Variable fresh not found'))),
      );
    });

    test('var declarations in a lambda shadow outer variables', () async {
      expect(
        await run('''
          function main() {
            x = 1;
            l = [5];
            l.forEach(function(e) { var x = e; });
            return x;
          }
        '''),
        equals(1),
      );
    });
  });

  group('Concurrency', () {
    test('concurrent runFunction calls on one interpreter do not share scope', () async {
      final interpreter = Interpreter(data: '''
        function id(x) { return x; }
        function f(n) {
          x = n;
          y = id(n);
          z = [id(x), id(y)];
          return z[0] * 10 + z[1];
        }
      ''');

      final results = await Future.wait([
        for (var n = 1; n <= 5; n++) interpreter.runFunction('f', arguments: {'n': n}),
      ]);

      expect(results, equals([11, 22, 33, 44, 55]));
    });
  });

  group('Runtime errors', () {
    test('carry the script call stack', () async {
      try {
        await run('''
          function inner() { return missing; }
          function outer() { return inner(); }
          function main() { return outer(); }
        ''');
        fail('expected an error');
      } on CapyScriptRuntimeError catch (e) {
        expect(e.frames, equals(['inner', 'outer', 'main']));
        expect(e.message, equals('Variable missing not found.'));
        expect(e.toString(), equals('Variable missing not found. [at inner ← outer ← main]'));
      }
    });

    test('try/catch still receives the plain message', () async {
      expect(
        await run('''
          function inner() { return missing; }
          function main() {
            try {
              inner();
            } catch (e) {
              return e;
            }
          }
        '''),
        equals('Variable missing not found.'),
      );
    });

    test('try/catch still receives thrown values', () async {
      expect(
        await run('''
          function inner() { throw {"code": 7}; }
          function main() {
            try {
              inner();
            } catch (e) {
              return e["code"];
            }
          }
        '''),
        equals(7),
      );
    });
  });
}
