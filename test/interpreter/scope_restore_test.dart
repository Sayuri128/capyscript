import 'package:test/test.dart';
import 'package:capyscript/Interpreter/interpreter.dart';

void main() {
  group('Scope restoration on error (reused interpreter)', () {
    test('a crashed call does not leak its locals into later calls', () async {
      final interp = Interpreter(data: '''
        function boom(): int { leaked = 999; return "not an int"; }
        function check() { return leaked; }
      ''');

      // First call throws (return type mismatch) mid-execution.
      await expectLater(interp.runFunction('boom'), throwsA(anything));

      // The scope stack must have been unwound, so `leaked` from boom's
      // frame must not be visible to a subsequent call.
      expect(await interp.runFunction('check'), isNot(999));
    });

    test('interpreter still usable after a thrown error', () async {
      final interp = Interpreter(data: '''
        function boom(): int { return "oops"; }
        function add(a, b) { return a + b; }
      ''');

      await expectLater(interp.runFunction('boom'), throwsA(anything));
      expect(
        await interp.runFunction('add', arguments: {'a': 2, 'b': 3}),
        equals(5),
      );
    });
  });
}
