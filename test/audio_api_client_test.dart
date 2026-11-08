import 'dart:convert';

import 'package:capyscript/api_clients/audio_api_client.dart';
import 'package:capyscript/modules/waka_models/audio/audio_source_reader.dart';
import 'package:capyscript/modules/waka_models/models/audio/audio_marker.dart';
import 'package:capyscript/modules/waka_models/models/audio/audio_track_source.dart';
import 'package:capyscript/modules/waka_models/models/config_info/content_kinds/content_kinds.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_concrete_view/manga_concrete_view.dart';
import 'package:test/test.dart';

void main() {
  group('AudioApiClient', () {
    const audioScript = '''
      import "audio_models";
      function getGallery(page, query, filters, feed) {
        return [buildGallery({"uid": "b" + page, "title": query, "cover": "c", "data": {"feed": feed}})];
      }
      function getConcrete(uid, data) {
        return buildConcrete({
          "uid": uid,
          "cover": "",
          "title": "Book",
          "description": "",
          "tags": ["fiction"],
          "groups": [buildChapterGroups({"title": "Tracks", "elements": [
            buildChapter({"uid": "t1", "title": "Part 1", "timestamp": null, "data": {"id": 1}, "number": 1}),
            buildChapter({"uid": "t2", "title": "Part 2", "timestamp": null, "data": {"id": 2}, "number": 2})
          ]})],
          "status": statusReleased(),
          "alternativeTitles": []
        });
      }
      function getRelated(uid, data) {
        return [buildGallery({"uid": uid + "-next", "title": "Next", "cover": "", "data": {}})];
      }
      function getAudioSources(uid, data) {
        return [
          buildAudioSource({
            "url": "https://cdn.example/" + uid + ".mp3",
            "format": "MP3",
            "quality": "128kbps",
            "headers": {"Referer": "https://example.org"},
            "duration": 754.5,
            "markers": [
              buildAudioMarker({"start": 300, "title": "Chapter 2"}),
              buildAudioMarker({"start": 0, "title": "Chapter 1"})
            ]
          }),
          buildAudioSource({"url": "https://cdn.example/" + uid + "-64.mp3", "quality": "64kbps"})
        ];
      }
    ''';

    test('gallery, concrete and related use the manga models', () async {
      final client = AudioApiClient(code: audioScript);

      final gallery = await client.getGallery(page: 2, query: 'q', feed: 'new');
      final concrete = await client.getConcrete(uid: 'b1', data: {});
      final related = await client.getRelated(uid: 'b1', data: {});

      expect(gallery.single.uid, 'b2');
      expect(gallery.single.title, 'q');
      expect(gallery.single.data['feed'], 'new');
      expect(concrete, isA<MangaConcreteView>());
      expect(concrete.groups.single.elements.map((e) => e.uid), ['t1', 't2']);
      expect(related.single.uid, 'b1-next');
    });

    test('getAudioSources returns the built sources', () async {
      final client = AudioApiClient(code: audioScript);

      final sources = await client.getAudioSources(uid: 't1', data: {'id': 1});

      expect(sources, hasLength(2));
      final first = sources.first;
      expect(first.url, 'https://cdn.example/t1.mp3');
      expect(first.format, 'mp3');
      expect(first.quality, '128kbps');
      expect(first.headers, {'Referer': 'https://example.org'});
      expect(first.duration, 754.5);
      expect(first.markers, const [
        AudioMarker(title: 'Chapter 1', start: 0),
        AudioMarker(title: 'Chapter 2', start: 300),
      ]);
      expect(sources.last.format, isNull);
      expect(sources.last.duration, isNull);
      expect(sources.last.markers, isEmpty);
      expect(sources.last.headers, isEmpty);
    });

    test('getImageHeaders is optional', () async {
      final client = AudioApiClient(code: audioScript);

      expect(await client.getImageHeaders(uid: 'b1', data: {}), isEmpty);
    });

    test('plain maps, a single source and null are accepted', () async {
      final fromMaps = AudioApiClient(code: '''
        function getAudioSources(uid, data) {
          return [{"url": " https://x/a.m4b ", "format": "m4b", "duration": "61", "markers": [{"start": "30", "title": "Two"}, {"title": "broken"}]}];
        }
      ''');
      final single = AudioApiClient(code: '''
        import "audio_models";
        function getAudioSources(uid, data) {
          return buildAudioSource({"url": "https://x/a.mp3"});
        }
      ''');
      final none = AudioApiClient(code: '''
        function getAudioSources(uid, data) {
          return null;
        }
      ''');

      final mapped = (await fromMaps.getAudioSources(uid: 'a', data: {})).single;
      expect(mapped.url, 'https://x/a.m4b');
      expect(mapped.format, AudioTrackSource.formatM4b);
      expect(mapped.duration, 61);
      expect(mapped.markers, const [AudioMarker(title: 'Two', start: 30)]);
      expect((await single.getAudioSources(uid: 'a', data: {})).single.url,
          'https://x/a.mp3');
      expect(await none.getAudioSources(uid: 'a', data: {}), isEmpty);
    });

    test('a missing url or a wrong result is an error', () async {
      final missingUrl = AudioApiClient(code: '''
        import "audio_models";
        function getAudioSources(uid, data) {
          return [buildAudioSource({"url": ""})];
        }
      ''');

      await expectLater(
          missingUrl.getAudioSources(uid: 'a', data: {}), throwsA(anything));
      expect(() => AudioSourceReader.readSources(42), throwsFormatException);
      expect(() => AudioSourceReader.readSource('x'), throwsFormatException);
    });

    test('invalid durations and markers are dropped', () {
      final source = AudioSourceReader.readSource(<String, dynamic>{
        'url': 'https://x',
        'duration': -3,
        'markers': 'nope',
      });

      expect(source.duration, isNull);
      expect(source.markers, isEmpty);
      expect(AudioSourceReader.readDuration(0), isNull);
      expect(AudioSourceReader.readDuration(double.nan), isNull);
    });

    test('buildAudioMarker requires a valid start', () async {
      final client = AudioApiClient(code: '''
        import "audio_models";
        function getAudioSources(uid, data) {
          return [buildAudioSource({"url": "https://x", "markers": [buildAudioMarker({"start": -1})]})];
        }
      ''');

      await expectLater(
          client.getAudioSources(uid: 'a', data: {}), throwsA(anything));
    });

    test('an audio source survives a json round trip', () {
      const source = AudioTrackSource(
        url: 'https://x/a.mp3',
        format: 'mp3',
        quality: 'HQ',
        headers: {'A': 'b'},
        duration: 12.5,
        markers: [AudioMarker(title: 'Intro', start: 0)],
      );

      final decoded =
          AudioTrackSource.fromJson(jsonDecode(jsonEncode(source.toJson())));

      expect(decoded.url, source.url);
      expect(decoded.format, 'mp3');
      expect(decoded.quality, 'HQ');
      expect(decoded.headers, {'A': 'b'});
      expect(decoded.duration, 12.5);
      expect(decoded.markers, source.markers);
      expect(source.getField('duration'), 12.5);
      expect(source.markers.single.getField('title'), 'Intro');
    });

    test('audiobook is a known content kind', () {
      expect(ContentKinds.known, contains(ContentKinds.audiobook));
      expect(ContentKinds.parse(<dynamic>[' Audiobook']), ['audiobook']);
    });
  });
}
