import 'package:capyscript/modules/waka_models/models/anime/anime_concrete_view/anime_status.dart';
import 'package:capyscript/modules/waka_models/models/anime/anime_concrete_view/anime_concrete_view.dart';
import 'package:capyscript/modules/waka_models/models/config_info/config_info.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_concrete_view/manga_concrete_view.dart';
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
}
