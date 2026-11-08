import 'package:test/test.dart';
import '../../helpers.dart';

void main() {
  group('html module', () {
    test('document text returns the text of the whole document', () async {
      expect(
        await run('''
          import "html";
          function main() {
            return createHTMLParser("<p>Hello</p><p>world</p>").text;
          }
        '''),
        equals('Helloworld'),
      );
    });

    test('element text still works', () async {
      expect(
        await run('''
          import "html";
          function main() {
            return createHTMLParser("<div><b>Bold</b> text</div>").querySelector("div").text;
          }
        '''),
        equals('Bold text'),
      );
    });
  });
}
