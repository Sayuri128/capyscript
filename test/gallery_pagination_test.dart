import 'dart:convert';

import 'package:capyscript/api_clients/host/extension_host.dart';
import 'package:capyscript/api_clients/manga_api_client.dart';
import 'package:capyscript/modules/waka_models/models/config_info/config_info.dart';
import 'package:capyscript/modules/waka_models/models/config_info/gallery_pagination/gallery_pagination.dart';
import 'package:capyscript/modules/waka_models/models/config_info/preferences/extension_preference.dart';
import 'package:test/test.dart';

Map<String, dynamic> _config(Object? pagination) => <String, dynamic>{
      'name': 'Test',
      'uid': 'test-uid',
      'logoUrl': '',
      'type': 0,
      'nsfw': false,
      'language': 'en',
      'version': 1,
      'filters': <dynamic>[],
      'searchAvailable': true,
      if (pagination != null) 'pagination': pagination,
    };

class _StoredPreferences extends ExtensionPreferencesProvider {
  final Map<String, Object?> values;

  const _StoredPreferences(this.values);

  @override
  Future<Object?> getPreference(String key) async => values[key];
}

class _FailingPreferences extends ExtensionPreferencesProvider {
  const _FailingPreferences();

  @override
  Future<Object?> getPreference(String key) async => throw StateError('down');
}

const String _echoPageSizeScript = '''
  import "manga_models";
  function getGallery(page, query, filters, feed, pageSize) {
    return [buildGallery({"uid": "size" + pageSize, "title": "", "cover": "", "data": {}})];
  }
''';

const GalleryPagination _pagination =
    GalleryPagination(pageSizes: [20, 50, 100], defaultPageSize: 50);

void main() {
  group('GalleryPagination parsing', () {
    test('configs without pagination parse it as absent', () {
      expect(ConfigInfo.fromJson(_config(null)).pagination, isNull);
    });

    test('valid pagination survives a json round trip', () {
      final config = ConfigInfo.fromJson(_config({
        'pageSizes': [20, 40, 100],
        'defaultPageSize': 40,
      }));
      final decoded =
          ConfigInfo.fromJson(jsonDecode(jsonEncode(config.toJson())));

      for (final parsed in [config, decoded]) {
        expect(parsed.pagination!.pageSizes, [20, 40, 100]);
        expect(parsed.pagination!.defaultPageSize, 40);
      }
    });

    test('invalid sizes are dropped and duplicates collapse', () {
      final pagination = GalleryPagination.tryParse({
        'pageSizes': [20, '40', 0, -5, 2.5, 'x', null, 20, 501, double.nan],
        'defaultPageSize': 40,
      })!;

      expect(pagination.pageSizes, [20, 40]);
      expect(pagination.defaultPageSize, 40);
    });

    test('a default outside the sizes falls back to the first size', () {
      final pagination = GalleryPagination.tryParse({
        'pageSizes': [30, 60],
        'defaultPageSize': 45,
      })!;

      expect(pagination.defaultPageSize, 30);
    });

    test('malformed pagination is treated as absent', () {
      expect(GalleryPagination.tryParse('20'), isNull);
      expect(GalleryPagination.tryParse({'pageSizes': 'all'}), isNull);
      expect(GalleryPagination.tryParse({'pageSizes': [0, -1]}), isNull);
      expect(
          ConfigInfo.fromJson(_config({'pageSizes': []})).pagination, isNull);
    });
  });

  group('page size resolution', () {
    test('extensions without pagination receive zero', () async {
      final client = MangaApiClient(code: _echoPageSizeScript);

      expect((await client.getGallery(page: 1)).single.uid, 'size0');
    });

    test('the declared default is used when nothing is stored', () async {
      final client = MangaApiClient(
        code: _echoPageSizeScript,
        host: const ExtensionHost(pagination: _pagination),
      );

      expect((await client.getGallery(page: 1)).single.uid, 'size50');
    });

    test('a stored allowed size wins, stored as int or string', () async {
      for (final Object stored in [100, '100']) {
        final client = MangaApiClient(
          code: _echoPageSizeScript,
          host: ExtensionHost(
            pagination: _pagination,
            preferences: _StoredPreferences(
                {ExtensionPreference.pageSizeKey: stored}),
          ),
        );

        expect((await client.getGallery(page: 1)).single.uid, 'size100');
      }
    });

    test('a stored size the config no longer offers falls back to the default',
        () async {
      final client = MangaApiClient(
        code: _echoPageSizeScript,
        host: const ExtensionHost(
          pagination: _pagination,
          preferences:
              _StoredPreferences({ExtensionPreference.pageSizeKey: 30}),
        ),
      );

      expect((await client.getGallery(page: 1)).single.uid, 'size50');
    });

    test('a failing preference provider falls back to the default', () async {
      final client = MangaApiClient(
        code: _echoPageSizeScript,
        host: const ExtensionHost(
          pagination: _pagination,
          preferences: _FailingPreferences(),
        ),
      );

      expect((await client.getGallery(page: 1)).single.uid, 'size50');
    });

    test('an explicit allowed size overrides the stored one', () async {
      final client = MangaApiClient(
        code: _echoPageSizeScript,
        host: const ExtensionHost(
          pagination: _pagination,
          preferences:
              _StoredPreferences({ExtensionPreference.pageSizeKey: 100}),
        ),
      );

      expect((await client.getGallery(page: 1, pageSize: 20)).single.uid,
          'size20');
      expect((await client.getGallery(page: 1, pageSize: 33)).single.uid,
          'size50');
    });

    test('scripts that do not declare pageSize keep working', () async {
      final client = MangaApiClient(
        code: '''
          import "manga_models";
          function getGallery(page, query, filters) {
            return [buildGallery({"uid": "p" + page, "title": "", "cover": "", "data": {}})];
          }
        ''',
        host: const ExtensionHost(pagination: _pagination),
      );

      expect((await client.getGallery(page: 3)).single.uid, 'p3');
    });
  });
}
