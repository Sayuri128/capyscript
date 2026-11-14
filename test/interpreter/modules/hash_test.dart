import 'package:test/test.dart';
import '../../helpers.dart';

void main() {
  group('hash module', () {
    test('digests strings as utf-8', () async {
      expect(
        await run(r'''
          import "hash";
          function main() { return [md5("abc"), sha1("abc"), sha256("abc")]; }
        '''),
        equals([
          '900150983cd24fb0d6963f7d28e17f72',
          'a9993e364706816aba3e25717850c26c9cd0d89d',
          'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad',
        ]),
      );
    });

    test('digests byte lists and formats base64 and bytes', () async {
      expect(
        await run(r'''
          import "hash";
          function main() {
            return [sha256([97, 98, 99], "base64"), md5("", "bytes").length];
          }
        '''),
        equals(['ungWv48Bz+pBQUDeXa4iI7ADYaOWF3qctBD/YfIAFa0=', 16]),
      );
    });

    test('hmac matches the RFC 4231 test vector', () async {
      expect(
        await run(r'''
          import "hash";
          function main() { return hmac("sha256", "Jefe", "what do ya want for nothing?"); }
        '''),
        equals('5bdcc146bf60754e6a042426089575c75a003f089d2739839dec58b964ec3843'),
      );
    });

    test('unknown algorithms and outputs are script errors', () async {
      await expectLater(
        run(r'''
          import "hash";
          function main() { return hmac("crc32", "k", "m"); }
        '''),
        throwsA(predicate((error) => error.toString().contains('unknown hash'))),
      );
      await expectLater(
        run(r'''
          import "hash";
          function main() { return md5("a", "binary"); }
        '''),
        throwsA(predicate((error) => error.toString().contains('unknown output'))),
      );
    });
  });
}
