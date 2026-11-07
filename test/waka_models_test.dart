import 'dart:convert';

import 'package:capyscript/modules/waka_models/models/anime/anime_concrete_view/anime_status.dart';
import 'package:capyscript/modules/waka_models/models/anime/anime_concrete_view/anime_concrete_view.dart';
import 'package:capyscript/modules/waka_models/models/config_info/config_info.dart';
import 'package:capyscript/modules/waka_models/models/anime/anime_gallery_view/anime_gallery_view.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_concrete_view/manga_concrete_view.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_concrete_view/manga_status.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_gallery_view/manga_gallery_view.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_gallery_view/filters/switcher/swircher.dart';
import 'package:capyscript/modules/waka_models/models/anime/anime_concrete_view/anime_video/anime_video.dart';
import 'package:capyscript/modules/waka_models/models/anime/anime_concrete_view/anime_video/anime_view_type.dart';
import 'package:capyscript/modules/waka_models/models/anime/anime_concrete_view/anime_video_group/anime_video_group.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_concrete_view/chapter/chapter.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_concrete_view/chapters_group/chapters_group.dart';
import 'package:test/test.dart';

import 'helpers.dart';

void main() {
  group('ElementsGroupOfConcrete.setField', () {
    test('assigning a List<dynamic> of chapters does not throw', () {
      final group = ChaptersGroup(
        title: 'Main',
        elements: [
          const Chapter(uid: 'c1', title: 'One', data: {}),
        ],
      );

      final List<dynamic> replacement = <dynamic>[
        const Chapter(uid: 'c2', title: 'Two', data: {}),
        const Chapter(uid: 'c3', title: 'Three', data: {}),
      ];

      expect(() => group.setField('elements', replacement), returnsNormally);
      expect(group.elements.map((e) => e.uid), <String>['c2', 'c3']);
    });

    test('assigning a List<dynamic> of videos does not throw', () {
      final group = AnimeVideoGroup(
        title: 'Season 1',
        elements: [
          const AnimeVideo(uid: 'e1', title: 'One', data: {}, type: AnimeVideoType.IFRAME, src: '', timestamp: null),
        ],
      );

      final List<dynamic> replacement = <dynamic>[
        const AnimeVideo(uid: 'e2', title: 'Two', data: {}, type: AnimeVideoType.IFRAME, src: '', timestamp: null),
      ];

      expect(() => group.setField('elements', replacement), returnsNormally);
      expect(group.elements.single.uid, 'e2');
    });

    test('assigning a list holding a wrong element type still throws', () {
      final group = ChaptersGroup(title: 'Main', elements: []);

      expect(
        () => group.setField('elements', <dynamic>['not a chapter']),
        throwsA(isA<TypeError>()),
      );
    });
  });

  group('AnimeVideoGroup.callFunction', () {
    test('copyWith accepts a List<dynamic> of videos', () {
      final group = AnimeVideoGroup(
        title: 'Season 1',
        elements: [const AnimeVideo(uid: 'e1', title: 'One', data: {}, type: AnimeVideoType.IFRAME, src: '', timestamp: null)],
      );

      final result = group.callFunction('copyWith', ordinalArguments: <dynamic>[
        'Season 2',
        <dynamic>[const AnimeVideo(uid: 'e2', title: 'Two', data: {}, type: AnimeVideoType.IFRAME, src: '', timestamp: null)],
      ]) as AnimeVideoGroup;

      expect(result.title, 'Season 2');
      expect(result.elements.single.uid, 'e2');
    });
  });

  group('ConfigInfo', () {
    Map<String, dynamic> config(List<Map<String, dynamic>> filters) => {
          'uid': 'u1',
          'name': 'Source',
          'logoUrl': 'https://example.com/logo.png',
          'type': 0,
          'nsfw': false,
          'language': 'English',
          'version': 1,
          'searchAvailable': true,
          'filters': filters,
        };

    test('skips filters with an unknown type instead of failing', () {
      final info = ConfigInfo.fromJson(config([
        {'type': 'SOMETHING_NEW', 'param': 'x', 'paramName': 'X'},
        {'type': 'SWITCHER', 'param': 'adult', 'paramName': 'Adult', 'onValue': '1', 'offValue': '0'},
      ]));

      expect(info.filters, hasLength(1));
      expect(info.filters.single, isA<GalleryFilterSwitcher>());
    });

    test('getField returns the field value for name', () {
      final info = ConfigInfo.fromJson(config([]));

      expect(info.getField('name'), 'Source');
    });

    test('download pacing is optional and defaults to no delay', () {
      final info = ConfigInfo.fromJson(config([]));

      expect(info.downloadConfig, isNull);
    });

    test('download pacing survives a json round trip', () {
      final info = ConfigInfo.fromJson({
        ...config([]),
        'downloadConfig': {'pageDelayMs': 400},
      });

      expect(info.downloadConfig?.pageDelayMs, 400);
      expect(info.downloadConfig?.chapterDelayMs, 0);

      final restored = ConfigInfo.fromJson(
        Map<String, dynamic>.from(jsonDecode(jsonEncode(info.toJson()))),
      );
      expect(restored.downloadConfig?.pageDelayMs, 400);
    });
  });

  group('anime_models', () {
    test('statusOngoing is available to scripts', () async {
      final result = await run('''
        import "anime_models";
        function main() {
          return statusOngoing();
        }
      ''');

      expect(result, AnimeStatus.ONGOING);
    });
  });

  group('buildConcrete metadata', () {
    test('manga accepts and normalizes authors, artists, year, rating and url', () async {
      final view = await run('''
        import "manga_models";
        function main() {
          return buildConcrete({
            "uid": "u", "cover": "c", "title": "t", "description": "d",
            "tags": [], "groups": [], "status": statusOngoing(), "alternativeTitles": [],
            "authors": ["A", " ", "A", "B"], "artists": ["C"],
            "year": "2019", "rating": "8,7", "url": "https://example.com/t"
          });
        }
      ''') as MangaConcreteView;

      expect(view.authors, ['A', 'B']);
      expect(view.artists, ['C']);
      expect(view.year, 2019);
      expect(view.rating, 8.7);
      expect(view.url, 'https://example.com/t');
      expect(MangaConcreteView.fromJson(view.toJson()).authors, ['A', 'B']);
    });

    test('scripts that pass no metadata still work', () async {
      final view = await run('''
        import "manga_models";
        function main() {
          return buildConcrete({
            "uid": "u", "cover": "c", "title": "t", "description": "d",
            "tags": [], "groups": [], "status": statusOngoing(), "alternativeTitles": []
          });
        }
      ''') as MangaConcreteView;

      expect(view.authors, isEmpty);
      expect(view.year, isNull);
      expect(view.rating, isNull);
      expect(view.url, isNull);
    });

    test('older cached json without metadata still decodes', () {
      final json = {
        'uid': 'u', 'cover': 'c', 'title': 't', 'alternativeTitles': <String>[],
        'description': 'd', 'tags': <String>[], 'status': 'ONGOING', 'groups': <dynamic>[],
      };

      final view = MangaConcreteView.fromJson(json);

      expect(view.authors, isEmpty);
      expect(view.artists, isEmpty);
      expect(view.rating, isNull);
    });

    test('rating is clamped and invalid values are dropped', () async {
      final view = await run('''
        import "anime_models";
        function main() {
          return buildConcrete({
            "uid": "u", "cover": "c", "title": "t", "description": "d",
            "tags": [], "groups": [], "alternativeTitles": [], "status": statusOngoing(),
            "rating": 42, "year": "unknown", "url": "not a url"
          });
        }
      ''') as AnimeConcreteView;

      expect(view.rating, 10);
      expect(view.year, isNull);
      expect(view.url, isNull);
    });
  });

  group('buildGallery metadata', () {
    test('manga accepts and normalizes status, subtitle, tags, year, rating and latest chapter', () async {
      final view = await run('''
        import "manga_models";
        function main() {
          return buildGallery({
            "uid": "u", "title": "t", "cover": "c", "data": {},
            "status": statusOngoing(), "subtitle": "  Original  ",
            "tags": ["Action", "", "Action", "Drama"], "year": "2020",
            "rating": "9,1", "latestChapter": 120
          });
        }
      ''') as MangaGalleryView;

      expect(view.status, MangaStatus.ONGOING);
      expect(view.subtitle, 'Original');
      expect(view.tags, ['Action', 'Drama']);
      expect(view.year, 2020);
      expect(view.rating, 9.1);
      expect(view.latestChapter, '120');
    });

    test('scripts that pass no metadata still work', () async {
      final view = await run('''
        import "manga_models";
        function main() {
          return buildGallery({"uid": "u", "title": "t", "cover": "c", "data": {}});
        }
      ''') as MangaGalleryView;

      expect(view.status, isNull);
      expect(view.subtitle, isNull);
      expect(view.tags, isEmpty);
      expect(view.year, isNull);
      expect(view.rating, isNull);
      expect(view.latestChapter, isNull);
    });

    test('metadata survives the json round trip used by getGallery', () async {
      final view = await run('''
        import "manga_models";
        function main() {
          return buildGallery({
            "uid": "u", "title": "t", "cover": "c", "data": {},
            "status": statusReleased(), "tags": ["A"], "rating": 7, "latestChapter": "Ch. 5"
          });
        }
      ''') as MangaGalleryView;

      final decoded = MangaGalleryView.fromJson(jsonDecode(jsonEncode(view)));

      expect(decoded.status, MangaStatus.RELEASED);
      expect(decoded.tags, ['A']);
      expect(decoded.rating, 7);
      expect(decoded.latestChapter, 'Ch. 5');
    });

    test('older gallery json without metadata still decodes', () {
      final view = MangaGalleryView.fromJson(
          {'uid': 'u', 'cover': 'c', 'title': 't', 'data': <String, dynamic>{}});

      expect(view.status, isNull);
      expect(view.tags, isEmpty);
    });

    test('anime keeps its status and accepts metadata', () async {
      final view = await run('''
        import "anime_models";
        function main() {
          return buildGallery({
            "uid": "u", "title": "t", "cover": "c", "data": {},
            "status": statusOngoing(), "year": 2024, "rating": 15, "subtitle": " "
          });
        }
      ''') as AnimeGalleryView;

      expect(view.status, AnimeStatus.ONGOING);
      expect(view.year, 2024);
      expect(view.rating, 10);
      expect(view.subtitle, isNull);
    });

    test('scripts can read metadata back from a gallery entry', () async {
      final result = await run('''
        import "manga_models";
        function main() {
          entry = buildGallery({
            "uid": "u", "title": "t", "cover": "c", "data": {},
            "tags": ["A", "B"], "latestChapter": "12"
          });
          return entry.latestChapter + ":" + entry.tags.length;
        }
      ''');

      expect(result, '12:2');
    });
  });
}
