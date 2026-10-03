import 'package:capyscript/parser/parser.dart';
import 'package:test/test.dart';

void main() {
  group('Parser errors', () {
    test('report the line and column of the offending token', () {
      const src = 'function main() {\n  x = 1;\n  return x )\n}';

      expect(
        () => Parser(source: src).parse(),
        throwsA(predicate((e) => e.toString().contains('at line 3:12'))),
      );
    });

    test('reject unexpected top-level tokens instead of dropping the rest of the file', () {
      const src = 'function a() { return 1; }\nx = 2;\nfunction b() { return 2; }';

      expect(
        () => Parser(source: src).parse(),
        throwsA(predicate((e) => e.toString().contains('at line 2:1'))),
      );
    });

    test('report unclosed strings with their start position', () {
      const src = 'function main() {\n  return "abc;\n}';

      expect(
        () => Parser(source: src).parse(),
        throwsA(predicate((e) => e.toString().contains('Unclosed string literal at line 2:10'))),
      );
    });

    test('accept trailing comments and whitespace', () {
      const src = 'function main() { return 1; }\n// done\n\n';

      expect(Parser(source: src).parse().functions.single.functionName, 'main');
    });
  });
}
