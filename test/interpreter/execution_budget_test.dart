import 'package:capyscript/Interpreter/execution_budget.dart';
import 'package:capyscript/Interpreter/interpreter.dart';
import 'package:test/test.dart';

void main() {
  group('Execution budget', () {
    test('stops an endless loop', () async {
      final interpreter = Interpreter(
        data: '''
          function main() {
            for(i = 0; i >= 0; i = i + 1) { }
            return i;
          }
        ''',
        budget: ExecutionBudget(maxLoopIterations: 1000),
      );

      expect(
        interpreter.interpret(),
        throwsA(predicate((e) => e.toString().contains('more than 1000 loop iterations'))),
      );
    });

    test('stops runaway recursion', () async {
      final interpreter = Interpreter(
        data: '''
          function down(n) { return down(n + 1); }
          function main() { return down(0); }
        ''',
        budget: ExecutionBudget(maxCallDepth: 50),
      );

      expect(
        interpreter.interpret(),
        throwsA(predicate((e) => e.toString().contains('call depth above 50'))),
      );
    });

    test('is reset for every top-level call', () async {
      final interpreter = Interpreter(
        data: '''
          function loop(n) {
            total = 0;
            for(i = 0; i < n; i = i + 1) { total = total + 1; }
            return total;
          }
        ''',
        budget: ExecutionBudget(maxLoopIterations: 100),
      );

      expect(await interpreter.runFunction('loop', arguments: {'n': 80}), 80);
      expect(await interpreter.runFunction('loop', arguments: {'n': 80}), 80);
    });

    test('allows ordinary recursion', () async {
      final interpreter = Interpreter(data: '''
        function fib(n) {
          if (n < 2) { return n; }
          return fib(n - 1) + fib(n - 2);
        }
        function main() { return fib(15); }
      ''');

      expect(await interpreter.interpret(), 610);
    });
  });
}
