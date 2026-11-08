import 'dart:convert';

import 'package:capyscript/modules/http/http_utils.dart';
import 'package:http/http.dart' as http;
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

      expect(url, 'https://example.com/manga/abc/def/feed');
    });
  
    test('joins params onto a url that already has a query', () async {
      final url = await HttpUtils.buildUri('https://example.com/search?type=1',
          params: {'q': 'a b'}, paths: {});

      expect(url, 'https://example.com/search?type=1&q=a%20b');
    });

    test('leaves a url with a query and no params unchanged', () async {
      final url = await HttpUtils.buildUri('https://example.com/feed?page=2',
          params: {}, paths: {});

      expect(url, 'https://example.com/feed?page=2');
    });

    test('keeps the trick of removing the appended question mark', () async {
      final url = await HttpUtils.buildUri('https://example.com/t?a=1&_=1',
          params: {}, paths: {'&_=1?': ''});

      expect(url, 'https://example.com/t?a=1');
    });
  });

  group('HttpUtils.decodeBody', () {
    test('decodes utf-8 when the server sends no charset', () {
      final response = http.Response.bytes(
          utf8.encode('<title>Café 月</title>'), 200,
          headers: {'content-type': 'application/atom+xml'});

      expect(HttpUtils.decodeBody(response), '<title>Café 月</title>');
    });

    test('falls back to latin-1 for bytes that are not utf-8', () {
      final response = http.Response.bytes(<int>[0x43, 0x61, 0x66, 0xE9], 200,
          headers: {'content-type': 'text/html'});

      expect(HttpUtils.decodeBody(response), 'Café');
    });

    test('respects an explicit charset', () {
      final response = http.Response.bytes(<int>[0x43, 0x61, 0x66, 0xE9], 200,
          headers: {'content-type': 'text/html; charset=iso-8859-1'});

      expect(HttpUtils.decodeBody(response), 'Café');
    });
  });
}
