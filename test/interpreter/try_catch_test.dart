import 'package:test/test.dart';
import '../helpers.dart';

void main() {
  group('throw / catch', () {
    test('catch binds the thrown value', () async {
      expect(
        await run('''
          function main() {
            try { throw "boom"; } catch (e) { return e; }
          }
        '''),
        equals('boom'),
      );
    });

    test('thrown value keeps its original type', () async {
      expect(
        await run('''
          function main() {
            try { throw 42; } catch (e) { return e; }
          }
        '''),
        equals(42),
      );
    });

    test('a runtime error is catchable with a message', () async {
      expect(
        await run('''
          function main() {
            try { var a = [1]; a.nope(); } catch (e) { return e; }
          }
        '''),
        contains('nope'),
      );
    });

    test('undefined variable read is catchable', () async {
      expect(
        await run('''
          function main() {
            try { return missing; } catch (e) { return "handled"; }
          }
        '''),
        equals('handled'),
      );
    });

    test('try block without error skips catch', () async {
      expect(
        await run('''
          function main() {
            try { return "ok"; } catch (e) { return "caught"; }
          }
        '''),
        equals('ok'),
      );
    });
  });

  group('finally', () {
    test('runs on success', () async {
      expect(
        await run('''
          function main() {
            var log = [];
            try { log.push("try"); } finally { log.push("finally"); }
            return log;
          }
        '''),
        equals(['try', 'finally']),
      );
    });

    test('runs after an error is caught', () async {
      expect(
        await run('''
          function main() {
            var log = [];
            try { throw "x"; } catch (e) { log.push("catch"); } finally { log.push("finally"); }
            return log;
          }
        '''),
        equals(['catch', 'finally']),
      );
    });

    test('runs even when try returns', () async {
      expect(
        await run('''
          function record(log) {
            try { return "returned"; } finally { log.push("finally"); }
          }
          function main() {
            var log = [];
            var r = record(log);
            log.push(r);
            return log;
          }
        '''),
        equals(['finally', 'returned']),
      );
    });
  });

  group('control flow is not swallowed', () {
    test('break inside try still breaks the loop', () async {
      expect(
        await run('''
          function main() {
            var count = 0;
            for (var i = 0; i < 5; i = i + 1) {
              try { if (i == 2) { break; } count = count + 1; } finally { }
            }
            return count;
          }
        '''),
        equals(2),
      );
    });

    test('continue inside try still continues', () async {
      expect(
        await run('''
          function main() {
            var count = 0;
            for (var i = 0; i < 5; i = i + 1) {
              try { if (i % 2 == 0) { continue; } count = count + 1; } finally { }
            }
            return count;
          }
        '''),
        equals(2),
      );
    });
  });
}
