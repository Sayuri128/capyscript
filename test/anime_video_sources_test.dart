import 'dart:convert';

import 'package:capyscript/api_clients/anime_api_client.dart';
import 'package:capyscript/modules/waka_models/models/anime/anime_concrete_view/anime_video/anime_video.dart';
import 'package:capyscript/modules/waka_models/models/anime/anime_concrete_view/anime_video/anime_video_source.dart';
import 'package:capyscript/modules/waka_models/models/anime/anime_concrete_view/anime_video/anime_video_subtitle.dart';
import 'package:capyscript/modules/waka_models/models/anime/anime_concrete_view/anime_video/anime_view_type.dart';
import 'package:test/test.dart';

import 'helpers.dart';

void main() {
  group('typeDirect', () {
    test('returns the DIRECT video type', () async {
      final result = await run('''
        import "anime_models";
        function main() {
          return typeDirect();
        }
      ''');

      expect(result, AnimeVideoType.DIRECT);
    });

    test('typeIframe still returns IFRAME', () async {
      final result = await run('''
        import "anime_models";
        function main() {
          return typeIframe();
        }
      ''');

      expect(result, AnimeVideoType.IFRAME);
    });
  });

  group('buildAnimeVideo', () {
    test('builds a DIRECT video with a literal data map', () async {
      final video = await run('''
        import "anime_models";
        function main() {
          return buildAnimeVideo({"uid": "e1", "title": "One", "timestamp": null, "data": {"id": 1}, "type": typeDirect(), "src": "episode-1"});
        }
      ''') as AnimeVideo;

      expect(video.type, AnimeVideoType.DIRECT);
      expect(video.data, <String, dynamic>{'id': 1});
      expect(video.toJson()['type'], 'DIRECT');
    });

    test('title is readable from scripts', () async {
      final result = await run('''
        import "anime_models";
        function main() {
          var video = buildAnimeVideo({"uid": "e1", "title": "One", "timestamp": "12:00", "data": {}, "type": typeIframe(), "src": "s"});
          return video.title;
        }
      ''');

      expect(result, 'One');
    });
  });

  group('buildAnimeVideoSource', () {
    test('builds a source with only a url', () async {
      final source = await run('''
        import "anime_models";
        function main() {
          return buildAnimeVideoSource({"url": "https://cdn.example/master.m3u8"});
        }
      ''') as AnimeVideoSource;

      expect(source.url, 'https://cdn.example/master.m3u8');
      expect(source.quality, isNull);
      expect(source.format, isNull);
      expect(source.headers, isEmpty);
      expect(source.subtitles, isEmpty);
    });

    test('builds a source with every field and coerces headers', () async {
      final source = await run('''
        import "anime_models";
        function main() {
          return buildAnimeVideoSource({
            "url": "https://cdn.example/1080.mp4",
            "quality": "1080p",
            "format": " MP4 ",
            "headers": {"Referer": "https://site.example/", "X-Retry": 3, "X-Empty": null},
            "subtitles": [
              buildAnimeVideoSubtitle({"url": "https://cdn.example/en.vtt", "label": "English", "language": "en", "format": "vtt"}),
              {"url": "https://cdn.example/uk.srt", "format": "SRT", "headers": {"Referer": "https://site.example/"}}
            ]
          });
        }
      ''') as AnimeVideoSource;

      expect(source.url, 'https://cdn.example/1080.mp4');
      expect(source.quality, '1080p');
      expect(source.format, 'mp4');
      expect(source.headers, <String, String>{
        'Referer': 'https://site.example/',
        'X-Retry': '3',
      });
      expect(source.headers, isA<Map<String, String>>());
      expect(source.subtitles, hasLength(2));
      expect(source.subtitles[0].label, 'English');
      expect(source.subtitles[0].language, 'en');
      expect(source.subtitles[0].format, 'vtt');
      expect(source.subtitles[1].url, 'https://cdn.example/uk.srt');
      expect(source.subtitles[1].format, 'srt');
      expect(source.subtitles[1].label, isNull);
      expect(source.subtitles[1].headers, <String, String>{'Referer': 'https://site.example/'});
    });

    test('null optional fields fall back to defaults', () async {
      final source = await run('''
        import "anime_models";
        function main() {
          return buildAnimeVideoSource({"url": "https://cdn.example/a.m3u8", "quality": null, "format": null, "headers": null, "subtitles": null});
        }
      ''') as AnimeVideoSource;

      expect(source.quality, isNull);
      expect(source.format, isNull);
      expect(source.headers, isEmpty);
      expect(source.subtitles, isEmpty);
    });

    test('a missing url throws', () async {
      expect(
        run('''
          import "anime_models";
          function main() {
            return buildAnimeVideoSource({"quality": "720p"});
          }
        '''),
        throwsA(predicate((error) => error.toString().contains('url is required'))),
      );
    });

    test('an empty url throws', () async {
      expect(
        run('''
          import "anime_models";
          function main() {
            return buildAnimeVideoSource({"url": "  "});
          }
        '''),
        throwsA(predicate((error) => error.toString().contains('url is required'))),
      );
    });

    test('fields are readable from scripts', () async {
      final result = await run('''
        import "anime_models";
        function main() {
          var source = buildAnimeVideoSource({"url": "https://cdn.example/a.m3u8", "quality": "Auto", "format": "hls"});
          return [source.url, source.quality, source.format];
        }
      ''');

      expect(result, ['https://cdn.example/a.m3u8', 'Auto', 'hls']);
    });
  });

  group('buildAnimeVideoSubtitle', () {
    test('builds a subtitle with only a url', () async {
      final subtitle = await run('''
        import "anime_models";
        function main() {
          return buildAnimeVideoSubtitle({"url": "https://cdn.example/en.vtt"});
        }
      ''') as AnimeVideoSubtitle;

      expect(subtitle.url, 'https://cdn.example/en.vtt');
      expect(subtitle.label, isNull);
      expect(subtitle.language, isNull);
      expect(subtitle.format, isNull);
      expect(subtitle.headers, isEmpty);
    });

    test('coerces header values to strings', () async {
      final subtitle = await run('''
        import "anime_models";
        function main() {
          return buildAnimeVideoSubtitle({"url": "https://cdn.example/en.vtt", "headers": {"X-Id": 42}});
        }
      ''') as AnimeVideoSubtitle;

      expect(subtitle.headers, <String, String>{'X-Id': '42'});
    });

    test('a missing url throws', () async {
      expect(
        run('''
          import "anime_models";
          function main() {
            return buildAnimeVideoSubtitle({"label": "English"});
          }
        '''),
        throwsA(predicate((error) => error.toString().contains('url is required'))),
      );
    });
  });

  group('JSON', () {
    test('AnimeVideo keeps the IFRAME serialization', () {
      const video = AnimeVideo(
        type: AnimeVideoType.IFRAME,
        uid: 'e1',
        src: 'https://player.example/embed/1',
        title: 'One',
        timestamp: null,
        data: {},
      );

      final json = video.toJson();
      expect(json['type'], 'IFRAME');

      final decoded = AnimeVideo.fromJson(jsonDecode(jsonEncode(json)));
      expect(decoded.type, AnimeVideoType.IFRAME);
      expect(decoded.src, 'https://player.example/embed/1');
    });

    test('AnimeVideo parses a legacy IFRAME payload', () {
      final decoded = AnimeVideo.fromJson({
        'uid': 'e1',
        'title': 'One',
        'data': <String, dynamic>{},
        'type': 'IFRAME',
        'src': 'https://player.example/embed/1',
        'timestamp': null,
      });

      expect(decoded.type, AnimeVideoType.IFRAME);
    });

    test('AnimeVideo round-trips DIRECT', () {
      const video = AnimeVideo(
        type: AnimeVideoType.DIRECT,
        uid: 'e2',
        src: 'episode-2',
        title: 'Two',
        timestamp: '24:00',
        data: {'id': 2},
      );

      final json = video.toJson();
      expect(json['type'], 'DIRECT');

      final decoded = AnimeVideo.fromJson(jsonDecode(jsonEncode(json)));
      expect(decoded.type, AnimeVideoType.DIRECT);
      expect(decoded.data, {'id': 2});
    });

    test('AnimeVideoSource round-trips with subtitles', () {
      const source = AnimeVideoSource(
        url: 'https://cdn.example/master.m3u8',
        quality: 'Auto',
        format: 'hls',
        headers: {'Referer': 'https://site.example/'},
        subtitles: [
          AnimeVideoSubtitle(
            url: 'https://cdn.example/en.vtt',
            label: 'English',
            language: 'en',
            format: 'vtt',
            headers: {'Origin': 'https://site.example'},
          ),
        ],
      );

      final encoded = jsonEncode(source.toJson());
      final decoded = AnimeVideoSource.fromJson(jsonDecode(encoded));

      expect(decoded.url, source.url);
      expect(decoded.quality, 'Auto');
      expect(decoded.format, 'hls');
      expect(decoded.headers, {'Referer': 'https://site.example/'});
      expect(decoded.subtitles.single.label, 'English');
      expect(decoded.subtitles.single.language, 'en');
      expect(decoded.subtitles.single.format, 'vtt');
      expect(decoded.subtitles.single.headers, {'Origin': 'https://site.example'});
    });

    test('AnimeVideoSource tolerates missing optional keys', () {
      final decoded = AnimeVideoSource.fromJson({'url': 'https://cdn.example/a.mp4'});

      expect(decoded.quality, isNull);
      expect(decoded.format, isNull);
      expect(decoded.headers, isEmpty);
      expect(decoded.subtitles, isEmpty);
    });

    test('AnimeVideoSubtitle tolerates missing optional keys', () {
      final decoded = AnimeVideoSubtitle.fromJson({'url': 'https://cdn.example/en.vtt'});

      expect(decoded.label, isNull);
      expect(decoded.language, isNull);
      expect(decoded.format, isNull);
      expect(decoded.headers, isEmpty);
    });
  });

  group('AnimeApiClient video sources', () {
    const video = AnimeVideo(
      type: AnimeVideoType.DIRECT,
      uid: 'ep-7',
      src: 'https://site.example/watch/7',
      title: 'Seven',
      timestamp: null,
      data: {'episodeId': 7},
    );

    test('supportsVideoSources is false when the script does not define it', () async {
      final client = AnimeApiClient(code: '''
        import "anime_models";
        function getConcrete(uid, data) {
          return null;
        }
      ''');

      expect(await client.supportsVideoSources(), isFalse);
    });

    test('supportsVideoSources ignores builtin module functions', () async {
      final client = AnimeApiClient(code: '''
        import "anime_models";
        function getConcrete(uid, data) {
          return null;
        }
      ''');

      expect(client.interpreter.hasFunction('buildAnimeVideoSource'), isFalse);
      expect(client.interpreter.hasFunction('getConcrete'), isTrue);
    });

    test('supportsVideoSources is true when the script defines it', () async {
      final client = AnimeApiClient(code: '''
        import "anime_models";
        function getVideoSources(uid, src, data) {
          return [];
        }
      ''');

      expect(await client.supportsVideoSources(), isTrue);
    });

    test('getVideoSources binds uid, src and data by name and returns built sources', () async {
      final client = AnimeApiClient(code: '''
        import "anime_models";
        function getVideoSources(data, src, uid) {
          return [
            buildAnimeVideoSource({
              "url": src + "/master.m3u8",
              "quality": "Auto",
              "format": "hls",
              "headers": {"X-Episode": data["episodeId"]},
              "subtitles": [buildAnimeVideoSubtitle({"url": src + "/" + uid + ".vtt", "language": "en"})]
            }),
            buildAnimeVideoSource({"url": src + "/720.mp4", "quality": "720p", "format": "mp4"})
          ];
        }
      ''');

      final sources = await client.getVideoSources(video);

      expect(sources, hasLength(2));
      expect(sources[0].url, 'https://site.example/watch/7/master.m3u8');
      expect(sources[0].format, 'hls');
      expect(sources[0].headers, {'X-Episode': '7'});
      expect(sources[0].subtitles.single.url, 'https://site.example/watch/7/ep-7.vtt');
      expect(sources[1].quality, '720p');
      expect(sources[1].format, 'mp4');
    });

    test('getVideoSources accepts plain maps', () async {
      final client = AnimeApiClient(code: '''
        function getVideoSources(uid, src, data) {
          return [{"url": "https://cdn.example/a.m3u8", "format": "hls", "headers": {"Referer": src}}];
        }
      ''');

      final sources = await client.getVideoSources(video);

      expect(sources.single.url, 'https://cdn.example/a.m3u8');
      expect(sources.single.format, 'hls');
      expect(sources.single.headers, {'Referer': 'https://site.example/watch/7'});
      expect(sources.single.subtitles, isEmpty);
    });

    test('getVideoSources returns an empty list when the script returns null', () async {
      final client = AnimeApiClient(code: '''
        function getVideoSources(uid, src, data) {
          return null;
        }
      ''');

      expect(await client.getVideoSources(video), isEmpty);
    });

    test('a script without getVideoSources still serves getConcrete', () async {
      final client = AnimeApiClient(code: '''
        import "anime_models";
        function getConcrete(uid, data) {
          return buildAnimeVideo({"uid": uid, "title": "One", "timestamp": null, "data": data, "type": typeIframe(), "src": "https://player.example/embed/1"});
        }
      ''');

      expect(await client.supportsVideoSources(), isFalse);
      final result = await client.interpreter.runFunction('getConcrete', arguments: {'uid': 'e1', 'data': <String, dynamic>{}});
      expect((result as AnimeVideo).type, AnimeVideoType.IFRAME);
    });
  });
}
