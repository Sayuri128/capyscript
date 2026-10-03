import 'package:capyscript/modules/waka_models/models/anime/anime_concrete_view/anime_status.dart';
import 'package:capyscript/modules/waka_models/models/config_info/config_info.dart';
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
}
