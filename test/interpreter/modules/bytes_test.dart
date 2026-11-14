import 'package:capyscript/modules/bytes/text_codecs.dart';
import 'package:test/test.dart';
import '../../helpers.dart';

void main() {
  group('bytes module', () {
    test('base64DecodeBytes accepts url-safe input without padding', () async {
      expect(
        await run(r'''
          import "bytes";
          function main() { return base64DecodeBytes("_-8"); }
        '''),
        equals([255, 239]),
      );
    });

    test('base64EncodeBytes and hex helpers round-trip', () async {
      expect(
        await run(r'''
          import "bytes";
          function main() {
            bytes = hexToBytes("00ff10");
            return [base64EncodeBytes(bytes), bytesToHex(base64DecodeBytes("AP8Q"))];
          }
        '''),
        equals(['AP8Q', '00ff10']),
      );
    });

    test('bytesToString decodes windows-1251 and koi8-r', () async {
      expect(
        await run(r'''
          import "bytes";
          function main() {
            return [
              bytesToString([207, 240, 232, 226, 229, 242], "windows-1251"),
              bytesToString([240, 210, 201, 215, 197, 212], "koi8-r"),
              bytesToString(stringToBytes("Їжак", "cp1251"), "windows-1251")
            ];
          }
        '''),
        equals(['Привет', 'Привет', 'Їжак']),
      );
    });

    test('bytesToString keeps going over malformed utf-8', () async {
      expect(
        await run(r'''
          import "bytes";
          function main() { return bytesToString([104, 255, 105]); }
        '''),
        equals('h�i'),
      );
    });

    test('charCodes and fromCharCodes mirror JavaScript', () async {
      expect(
        await run(r'''
          import "bytes";
          function main() {
            codes = charCodes("Aя");
            return [codes, fromCharCodes(codes)];
          }
        '''),
        equals([
          [65, 1103],
          'Aя'
        ]),
      );
    });

    test('xorBytes repeats a string key', () async {
      expect(
        await run(r'''
          import "bytes";
          function main() {
            secret = xorBytes(stringToBytes("hello"), "ab");
            return bytesToString(xorBytes(secret, stringToBytes("ab")));
          }
        '''),
        equals('hello'),
      );
    });

    test('bytesToInts reads big and little endian integers', () async {
      expect(
        await run(r'''
          import "bytes";
          function main() {
            return [
              bytesToInts([0, 0, 1, 2, 255, 255, 255, 255, 9]),
              bytesToInts([1, 2], 2, false),
              bytesToInts([255, 254], 2, true, true)
            ];
          }
        '''),
        equals([
          [258, 4294967295],
          [513],
          [-2]
        ]),
      );
    });

    test('bit operations follow JavaScript 32-bit semantics when wrapped',
        () async {
      expect(
        await run(r'''
          import "bytes";
          function main() {
            return [
              bitAnd(12, 10), bitOr(12, 10), bitXor(12, 10),
              toInt32(bitNot(0)), toInt32(shiftLeft(1, 31)),
              shiftRight(-8, 1), shiftRightUnsigned(-1, 28), toUint32(-1)
            ];
          }
        '''),
        equals([8, 14, 6, -1, -2147483648, -4, 15, 4294967295]),
      );
    });

    test('unknown encodings and non-byte input are script errors', () async {
      await expectLater(
        run(r'''
          import "bytes";
          function main() { return bytesToString([65], "utf-16"); }
        '''),
        throwsA(predicate((error) => error.toString().contains('unsupported encoding'))),
      );
      await expectLater(
        run(r'''
          import "bytes";
          function main() { return bytesToHex("ab"); }
        '''),
        throwsA(predicate((error) => error.toString().contains('list of bytes'))),
      );
    });
  });

  group('TextCodecs', () {
    test('every single-byte table round-trips its upper half', () {
      for (final String encoding in ['windows-1251', 'koi8-r', 'koi8-u']) {
        final List<int> bytes = [for (int byte = 0; byte < 256; byte++) byte];
        expect(TextCodecs.encode(TextCodecs.decode(bytes, encoding), encoding),
            equals(bytes),
            reason: encoding);
      }
    });

    test('canonicalName knows common aliases', () {
      expect(TextCodecs.canonicalName('CP1251'), 'windows-1251');
      expect(TextCodecs.canonicalName('UTF8'), 'utf-8');
      expect(TextCodecs.canonicalName('ISO-8859-1'), 'latin1');
      expect(TextCodecs.canonicalName('shift_jis'), isNull);
    });
  });
}
