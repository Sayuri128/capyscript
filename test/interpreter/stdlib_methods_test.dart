import 'package:test/test.dart';
import '../helpers.dart';

void main() {
  group('List methods', () {
    test('contains', () async {
      expect(await run('function main() { var a = [1,2,3]; return a.contains(2); }'),
          isTrue);
    });

    test('indexOf', () async {
      expect(await run('function main() { var a = [1,2,3]; return a.indexOf(3); }'),
          equals(2));
    });

    test('join', () async {
      expect(
          await run('function main() { var a = [1,2,3]; return a.join("-"); }'),
          equals('1-2-3'));
    });

    test('sublist with one arg', () async {
      expect(
          await run('function main() { var a = [1,2,3,4]; return a.sublist(2); }'),
          equals([3, 4]));
    });

    test('reversed', () async {
      expect(
          await run('function main() { var a = [1,2,3]; return a.reversed(); }'),
          equals([3, 2, 1]));
    });

    test('sort', () async {
      expect(
          await run('function main() { var a = [3,1,2]; a.sort(); return a; }'),
          equals([1, 2, 3]));
    });

    test('insert', () async {
      expect(
          await run(
              'function main() { var a = [1,3]; a.insert(1, 2); return a; }'),
          equals([1, 2, 3]));
    });
  });

  group('String methods', () {
    test('startsWith', () async {
      expect(await run('function main() { return "hello".startsWith("he"); }'),
          isTrue);
    });

    test('endsWith', () async {
      expect(await run('function main() { return "hello".endsWith("lo"); }'),
          isTrue);
    });

    test('indexOf', () async {
      expect(await run('function main() { return "hello".indexOf("l"); }'),
          equals(2));
    });

    test('substring with one arg', () async {
      expect(await run('function main() { return "hello".substring(2); }'),
          equals('llo'));
    });
  });

  group('Unsupported calls are loud', () {
    test('unknown list method throws', () async {
      expect(run('function main() { var a = [1]; return a.nope(); }'),
          throwsA(anything));
    });

    test('method on null throws', () async {
      expect(run('function main() { var a = null; return a.nope(); }'),
          throwsA(anything));
    });
  });
}
