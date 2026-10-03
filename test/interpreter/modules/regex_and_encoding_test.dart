import 'package:test/test.dart';
import '../../helpers.dart';

void main() {
  group('regex module', () {
    test('regexTest honours flags', () async {
      expect(
        await run(r'''
          import "regex";
          function main() {
            return [regexTest("chapter \d+", "Chapter 12"), regexTest("chapter \d+", "Chapter 12", "i")];
          }
        '''),
        equals([false, true]),
      );
    });

    test('regexMatch returns the whole match and groups', () async {
      expect(
        await run(r'''
          import "regex";
          function main() {
            return regexMatch("vol\.(\d+) ch\.(\d+)", "Vol. vol.3 ch.27 end");
          }
        '''),
        equals(['vol.3 ch.27', '3', '27']),
      );
    });

    test('regexMatch returns null without a match', () async {
      expect(
        await run(r'''
          import "regex";
          function main() { return regexMatch("\d", "none"); }
        '''),
        isNull,
      );
    });

    test('regexMatchAll returns every match', () async {
      expect(
        await run(r'''
          import "regex";
          function main() { return regexMatchAll("id=(\d+)", "id=1&id=22"); }
        '''),
        equals([
          ['id=1', '1'],
          ['id=22', '22'],
        ]),
      );
    });

    test('regexReplace expands groups and literal dollars', () async {
      expect(
        await run(r'''
          import "regex";
          function main() { return regexReplace("(\w+)@(\w+)", "a@b c@d", "$2:$1 $$"); }
        '''),
        equals(r'b:a $ d:c $'),
      );
    });

    test('regexSplit splits on the pattern', () async {
      expect(
        await run(r'''
          import "regex";
          function main() { return regexSplit("\s*,\s*", "a , b,c"); }
        '''),
        equals(['a', 'b', 'c']),
      );
    });

    test('works with backtick patterns', () async {
      expect(
        await run('''
          import "regex";
          function main() { return regexMatch(`"id":\\s*(\\d+)`, '{"id": 42}')[1]; }
        '''),
        equals('42'),
      );
    });
  });

  group('converter encoders', () {
    test('base64 round-trips utf-8 and tolerates missing padding', () async {
      expect(
        await run('''
          import "converter";
          function main() {
            return [base64Encode("наруто"), base64Decode(base64Encode("наруто")), base64Decode("YWI")];
          }
        '''),
        equals(['0L3QsNGA0YPRgtC+', 'наруто', 'ab']),
      );
    });

    test('urlEncode and urlDecode', () async {
      expect(
        await run('''
          import "converter";
          function main() { return [urlEncode("a b&c"), urlDecode("a%20b%26c")]; }
        '''),
        equals(['a%20b%26c', 'a b&c']),
      );
    });
  });
}
