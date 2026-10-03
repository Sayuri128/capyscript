import 'package:capyscript/modules/http/http_utils.dart';
import 'package:test/test.dart';

void main() {
  group('HttpUtils.buildUri', () {
    test('encodes reserved characters in query values', () async {
      final url = await HttpUtils.buildUri('https://example.com/search',
          params: {'q': 'c++ & co #1', 'page': 2}, paths: {});

      expect(url, 'https://example.com/search?q=c%2B%2B%20%26%20co%20%231&page=2');
      expect(Uri.parse(url).queryParameters['q'], 'c++ & co #1');
    });

    test('encodes non-ascii values as utf-8', () async {
      final url = await HttpUtils.buildUri('https://example.com/search',
          params: {'story': 'наруто'}, paths: {});

      expect(Uri.parse(url).queryParameters['story'], 'наруто');
    });

    test('keeps bracketed keys and encodes list and map values', () async {
      final url = await HttpUtils.buildUri('https://example.com/manga',
          params: {
            'includes': ['cover_art', 'a b'],
            'order': {'chapter': 'asc'},
          },
          paths: {});

      expect(url,
          'https://example.com/manga?includes[]=cover_art&includes[]=a%20b&order[chapter]=asc');
    });

    test('substitutes path placeholders verbatim', () async {
      final url = await HttpUtils.buildUri('https://example.com/manga/:uid/feed',
          params: {}, paths: {':uid': 'abc/def'});

      expect(url, 'https://example.com/manga/abc/def/feed?');
    });
  });
}
