import 'package:test/test.dart';
import '../helpers.dart';

void main() {
  group('Undefined variables are loud', () {
    test('reading an undefined variable throws', () async {
      expect(
        run('function main() { return missingValue; }'),
        throwsA(anything),
      );
    });

    test('typo in a value position throws instead of yielding a string',
        () async {
      expect(
        run('function main() { var title = "ok"; return titel; }'),
        throwsA(anything),
      );
    });
  });

  group('Backward-compatible bareword uses still work', () {
    test('function calls resolve by name', () async {
      expect(
        await run('''
          function greet() { return "hi"; }
          function main() { return greet(); }
        '''),
        equals('hi'),
      );
    });

    test('unquoted map keys resolve to their identifier text', () async {
      expect(
        await run('function main() { var m = { code: 5 }; return m["code"]; }'),
        equals(5),
      );
    });

    test('named-argument call with unquoted key', () async {
      expect(
        await run('''
          function f(code) { return code; }
          function main() { return f({ code: 7 }); }
        '''),
        equals(7),
      );
    });
  });
}
