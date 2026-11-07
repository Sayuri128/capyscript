import 'dart:convert';

import 'package:capyscript/modules/waka_models/models/anime/anime_concrete_view/anime_video/anime_video.dart';
import 'package:capyscript/modules/waka_models/models/anime/anime_concrete_view/anime_video/anime_view_type.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_concrete_view/chapter/chapter.dart';
import 'package:test/test.dart';

import 'helpers.dart';

Future<AnimeVideo> buildVideo(String extraArguments) async {
  final video = await run('''
    import "anime_models";
    function main() {
      return buildAnimeVideo({"uid": "e1", "title": "One", "timestamp": null, "data": {}, "type": typeIframe(), "src": "s"$extraArguments});
    }
  ''');
  return video as AnimeVideo;
}

Future<Chapter> buildChapterWith(String extraArguments) async {
  final chapter = await run('''
    import "manga_models";
    function main() {
      return buildChapter({"uid": "c1", "title": "One", "timestamp": null, "data": {}$extraArguments});
    }
  ''');
  return chapter as Chapter;
}

void main() {
  group('buildAnimeVideo number', () {
    final cases = <String, double?>{
      '12': 12.0,
      '12.5': 12.5,
      '"12.5"': 12.5,
      '" 7 "': 7.0,
      '"12,5"': 12.5,
      '0': 0.0,
      '"abc"': null,
      '""': null,
      'null': null,
      '-1': null,
      'true': null,
      '{}': null,
      '[1]': null,
    };

    for (final entry in cases.entries) {
      test('coerces ${entry.key} to ${entry.value}', () async {
        final video = await buildVideo(', "number": ${entry.key}');

        expect(video.number, entry.value);
      });
    }

    test('is null when omitted', () async {
      final video = await buildVideo('');

      expect(video.number, isNull);
      expect(video.season, isNull);
    });
  });

  group('buildAnimeVideo season', () {
    final cases = <String, int?>{
      '2': 2,
      '"3"': 3,
      '" 4 "': 4,
      '2.0': 2,
      '0': 0,
      '2.5': null,
      '"abc"': null,
      'null': null,
      '-1': null,
      'false': null,
    };

    for (final entry in cases.entries) {
      test('coerces ${entry.key} to ${entry.value}', () async {
        final video = await buildVideo(', "season": ${entry.key}');

        expect(video.season, entry.value);
      });
    }
  });

  group('AnimeVideo fields', () {
    test('number and season are readable from scripts', () async {
      final result = await run('''
        import "anime_models";
        function main() {
          var video = buildAnimeVideo({"uid": "e1", "title": "One", "timestamp": null, "data": {}, "type": typeIframe(), "src": "s", "number": "12.5", "season": 2});
          return [video.number, video.season];
        }
      ''');

      expect(result, [12.5, 2]);
    });

    test('getField returns null without numbering', () {
      const video = AnimeVideo(
        type: AnimeVideoType.IFRAME,
        uid: 'e1',
        src: 's',
        title: 'One',
        timestamp: null,
        data: {},
      );

      expect(video.getField('number'), isNull);
      expect(video.getField('season'), isNull);
    });

    test('copyWith keeps and replaces numbering', () {
      const video = AnimeVideo(
        type: AnimeVideoType.IFRAME,
        uid: 'e1',
        src: 's',
        title: 'One',
        timestamp: null,
        data: {},
        number: 3,
        season: 1,
      );

      expect(video.copyWith(title: 'Two').number, 3);
      expect(video.copyWith(title: 'Two').season, 1);
      expect(video.copyWith(number: 4.5).number, 4.5);
      expect(video.copyWith(season: 2).season, 2);
    });
  });

  group('AnimeVideo JSON numbering', () {
    test('omits number and season when absent', () {
      const video = AnimeVideo(
        type: AnimeVideoType.IFRAME,
        uid: 'e1',
        src: 's',
        title: 'One',
        timestamp: null,
        data: {},
      );

      expect(video.toJson(), {
        'uid': 'e1',
        'title': 'One',
        'data': <String, dynamic>{},
        'type': 'IFRAME',
        'src': 's',
        'timestamp': null,
      });
    });

    test('round-trips number and season', () {
      const video = AnimeVideo(
        type: AnimeVideoType.DIRECT,
        uid: 'e1',
        src: 's',
        title: 'One',
        timestamp: null,
        data: {},
        number: 12.5,
        season: 2,
      );

      final json = video.toJson();
      expect(json['number'], 12.5);
      expect(json['season'], 2);

      final decoded = AnimeVideo.fromJson(jsonDecode(jsonEncode(json)));
      expect(decoded.number, 12.5);
      expect(decoded.season, 2);
    });

    test('decodes an integral number as a double', () {
      final decoded = AnimeVideo.fromJson(jsonDecode(
          '{"uid":"e1","title":"One","data":{},"type":"IFRAME","src":"s","timestamp":null,"number":12,"season":1}'));

      expect(decoded.number, 12.0);
      expect(decoded.number, isA<double>());
      expect(decoded.season, 1);
    });

    test('decodes a legacy payload without numbering', () {
      final decoded = AnimeVideo.fromJson(jsonDecode(
          '{"uid":"e1","title":"One","data":{},"type":"IFRAME","src":"s","timestamp":null}'));

      expect(decoded.number, isNull);
      expect(decoded.season, isNull);
    });
  });

  group('buildChapter numbering', () {
    final numberCases = <String, double?>{
      '12': 12.0,
      '12.5': 12.5,
      '"12.5"': 12.5,
      '"abc"': null,
      'null': null,
    };

    for (final entry in numberCases.entries) {
      test('coerces number ${entry.key} to ${entry.value}', () async {
        final chapter = await buildChapterWith(', "number": ${entry.key}');

        expect(chapter.number, entry.value);
      });
    }

    final volumeCases = <String, int?>{
      '3': 3,
      '"4"': 4,
      '1.5': null,
      '"abc"': null,
      'null': null,
    };

    for (final entry in volumeCases.entries) {
      test('coerces volume ${entry.key} to ${entry.value}', () async {
        final chapter = await buildChapterWith(', "volume": ${entry.key}');

        expect(chapter.volume, entry.value);
      });
    }

    test('is null when omitted', () async {
      final chapter = await buildChapterWith('');

      expect(chapter.number, isNull);
      expect(chapter.volume, isNull);
    });

    test('number and volume are readable from scripts', () async {
      final result = await run('''
        import "manga_models";
        function main() {
          var chapter = buildChapter({"uid": "c1", "title": "One", "timestamp": null, "data": {}, "number": 7, "volume": "2"});
          return [chapter.number, chapter.volume];
        }
      ''');

      expect(result, [7.0, 2]);
    });
  });

  group('Chapter JSON numbering', () {
    test('omits number and volume when absent', () {
      const chapter = Chapter(uid: 'c1', title: 'One', data: {});

      expect(chapter.toJson(), {
        'uid': 'c1',
        'title': 'One',
        'data': <String, dynamic>{},
        'timestamp': null,
      });
      expect(chapter.getField('number'), isNull);
      expect(chapter.getField('volume'), isNull);
    });

    test('round-trips number and volume', () {
      const chapter =
          Chapter(uid: 'c1', title: 'One', data: {}, number: 101.5, volume: 9);

      final decoded = Chapter.fromJson(jsonDecode(jsonEncode(chapter.toJson())));
      expect(decoded.number, 101.5);
      expect(decoded.volume, 9);
      expect(decoded.getField('number'), 101.5);
      expect(decoded.getField('volume'), 9);
    });

    test('decodes a legacy payload without numbering', () {
      final decoded = Chapter.fromJson(jsonDecode(
          '{"uid":"c1","title":"One","data":{},"timestamp":null}'));

      expect(decoded.number, isNull);
      expect(decoded.volume, isNull);
    });
  });

  group('named arguments', () {
    test('extra map keys are ignored by functions that do not declare them', () async {
      final result = await run('''
        function build(uid) {
          return uid;
        }
        function main() {
          return build({"uid": "e1", "number": 12.5, "season": 2});
        }
      ''');

      expect(result, 'e1');
    });
  });
}
