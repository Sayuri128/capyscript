import 'dart:convert';

import 'package:capyscript/Interpreter/interpreter.dart';
import 'package:capyscript/api_clients/host/extension_host.dart';
import 'package:capyscript/api_clients/manga_api_client.dart';
import 'package:capyscript/api_clients/source_error.dart';
import 'package:capyscript/capyscript_api_version.dart';
import 'package:capyscript/AST/ast_tree.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/abstract/native_function_node.dart';
import 'package:capyscript/modules/waka_models/anime/anime_video_source_reader.dart';
import 'package:capyscript/modules/waka_models/models/anime/anime_concrete_view/anime_video/anime_skip_marker.dart';
import 'package:capyscript/modules/waka_models/models/anime/anime_concrete_view/anime_video/anime_video_source.dart';
import 'package:capyscript/modules/waka_models/models/config_info/config_info.dart';
import 'package:capyscript/modules/waka_models/models/config_info/download_config/download_config.dart';
import 'package:capyscript/modules/waka_models/models/config_info/preferences/extension_preference.dart';
import 'package:test/test.dart';

import 'helpers.dart';

Map<String, dynamic> _baseConfig() => <String, dynamic>{
      'name': 'Test',
      'uid': 'test-uid',
      'logoUrl': '',
      'type': 0,
      'nsfw': false,
      'language': 'en',
      'version': 1,
      'filters': <dynamic>[],
      'searchAvailable': true,
    };

class _MapPreferences extends ExtensionPreferencesProvider {
  final Map<String, Object?> values;

  const _MapPreferences(this.values);

  @override
  Future<Object?> getPreference(String key) async => values[key];
}

class _ThrowingModule extends BaseModule {
  static const String module_name = 'contract_test_errors';

  _ThrowingModule() : super(moduleName: module_name) {
    body = ASTTree(functions: [
      NativeFunctionNode(
        name: 'contractThrow',
        parameters: [ASTParameterNode('kind', paramType: 'string')],
        implementation: (arguments) => throw SourceError(
            sourceErrorKindFromName(arguments['kind'] as String)!, 'gone'),
      ).toDeclarationNode(),
    ], modules: []);
  }
}

void main() {
  group('api version', () {
    test('the interpreter advertises a newer api than legacy extensions', () {
      expect(capyscriptApiVersion, greaterThan(legacyExtensionApiVersion));
    });
  });

  group('ConfigInfo contract', () {
    test('an old config parses with defaults for every new field', () {
      final config = ConfigInfo.fromJson(_baseConfig());

      expect(config.apiVersion, 1);
      expect(config.minAppVersion, isNull);
      expect(config.preferences, isEmpty);
      expect(config.requestPolicy, isNull);
      expect(config.feeds, isEmpty);
    });

    test('new fields parse and survive a json round trip', () {
      final json = _baseConfig()
        ..addAll(<String, dynamic>{
          'apiVersion': 2,
          'minAppVersion': '1.5.0',
          'preferences': <dynamic>[
            {
              'key': 'lang',
              'type': 'select',
              'title': 'Language',
              'summary': 'Content language',
              'default': 'en',
              'options': [
                {'value': 'en', 'label': 'English'},
                {'value': 'uk', 'label': 'Ukrainian'},
              ],
            },
            {'key': 'adult', 'type': 'toggle', 'title': 'Adult', 'default': true},
            {'key': 'future', 'type': 'colorPicker', 'title': 'Unknown type'},
          ],
          'requestPolicy': {
            'rateLimit': {'requests': 4, 'perSeconds': 1.5},
            'defaultHeaders': {'Referer': 'https://example.org'},
            'userAgent': 'UA',
            'mirrors': ['https://a.example', 'https://b.example'],
          },
          'feeds': [
            {'id': 'popular', 'title': 'Popular'},
            {'id': 'latest', 'title': 'Latest'},
            {'title': 'missing id'},
          ],
          'downloadConfig': {'segmentConcurrency': 5, 'episodeDelayMs': 250},
        });

      final config = ConfigInfo.fromJson(json);
      final decoded =
          ConfigInfo.fromJson(jsonDecode(jsonEncode(config.toJson())));

      for (final parsed in [config, decoded]) {
        expect(parsed.apiVersion, 2);
        expect(parsed.minAppVersion, '1.5.0');
        expect(parsed.preferences.map((e) => e.key), ['lang', 'adult']);
        expect(parsed.preferences.first.type, ExtensionPreferenceType.select);
        expect(parsed.preferences.first.options.last.label, 'Ukrainian');
        expect(parsed.preferences.first.defaultValue, 'en');
        expect(parsed.preferences.last.defaultValue, true);
        expect(parsed.requestPolicy!.rateLimit!.requests, 4);
        expect(parsed.requestPolicy!.rateLimit!.window,
            const Duration(milliseconds: 1500));
        expect(parsed.requestPolicy!.defaultHeaders,
            {'Referer': 'https://example.org'});
        expect(parsed.requestPolicy!.userAgent, 'UA');
        expect(parsed.requestPolicy!.mirrors, hasLength(2));
        expect(parsed.feeds.map((e) => e.id), ['popular', 'latest']);
        expect(parsed.downloadConfig!.segmentConcurrency, 5);
        expect(parsed.downloadConfig!.episodeDelayMs, 250);
        expect(parsed.downloadConfig!.pageDelayMs, 0);
      }
    });

    test('an old download config leaves the new fields unset', () {
      final config = DownloadConfig.fromJson({'pageDelayMs': 10});

      expect(config.segmentConcurrency, isNull);
      expect(config.episodeDelayMs, 0);
    });
  });

  group('ExtensionPreference defaults', () {
    test('effective defaults fall back per type', () {
      const select = ExtensionPreference(
        key: 's',
        type: ExtensionPreferenceType.select,
        title: 'S',
        options: [ExtensionPreferenceOption(value: 'a', label: 'A')],
      );
      const toggle = ExtensionPreference(
          key: 't', type: ExtensionPreferenceType.toggle, title: 'T');
      const multi = ExtensionPreference(
          key: 'm',
          type: ExtensionPreferenceType.multiselect,
          title: 'M',
          defaultValue: ['x', 1]);
      const number = ExtensionPreference(
          key: 'n', type: ExtensionPreferenceType.number, title: 'N');
      const text = ExtensionPreference(
          key: 'x', type: ExtensionPreferenceType.text, title: 'X');

      expect(select.effectiveDefault, 'a');
      expect(toggle.effectiveDefault, false);
      expect(multi.effectiveDefault, ['x', '1']);
      expect(number.effectiveDefault, 0);
      expect(text.effectiveDefault, '');
    });
  });

  group('ExtensionHost', () {
    test('resolvePreference prefers a stored value over the declared default',
        () async {
      const host = ExtensionHost(
        extensionUid: 'uid',
        preferenceDefinitions: [
          ExtensionPreference(
              key: 'a',
              type: ExtensionPreferenceType.text,
              title: 'A',
              defaultValue: 'fallback'),
          ExtensionPreference(
              key: 'b',
              type: ExtensionPreferenceType.text,
              title: 'B',
              defaultValue: 'fallback'),
        ],
        preferences: _MapPreferences({'a': 'stored'}),
      );

      expect(await host.resolvePreference('a'), 'stored');
      expect(await host.resolvePreference('b'), 'fallback');
      expect(await host.resolvePreference('missing'), isNull);
    });

    test('the noop storage reads nothing', () async {
      const storage = NoopExtensionStorage();
      await storage.write('k', 'v', ttl: const Duration(seconds: 1));

      expect(await storage.read('k'), isNull);
    });

    test('module factories receive the interpreter host', () {
      ExtensionHost? received;
      moduleFactories['contract_test_host'] = (host) {
        received = host;
        return _ThrowingModule();
      };
      addTearDown(() => moduleFactories.remove('contract_test_host'));

      const host = ExtensionHost(extensionUid: 'owner');
      Interpreter(data: '', host: host).builtinModule('contract_test_host');

      expect(received, same(host));
    });
  });

  group('SourceError', () {
    setUp(() {
      moduleFactories[_ThrowingModule.module_name] = (_) => _ThrowingModule();
    });
    tearDown(() => moduleFactories.remove(_ThrowingModule.module_name));

    test('kind names map back to kinds', () {
      for (final kind in SourceErrorKind.values) {
        expect(sourceErrorKindFromName(kind.name), kind);
      }
      expect(sourceErrorKindFromName('nope'), isNull);
      expect(sourceErrorKindFromName(null), isNull);
    });

    test('runFunction rethrows a source error unwrapped', () async {
      final interpreter = Interpreter(data: '''
        import "contract_test_errors";
        function helper() {
          contractThrow("notFound");
        }
        function getConcrete(uid, data) {
          helper();
        }
      ''');

      await expectLater(
        interpreter.runFunction('getConcrete', arguments: {'uid': 'x', 'data': {}}),
        throwsA(isA<SourceError>()
            .having((e) => e.kind, 'kind', SourceErrorKind.notFound)
            .having((e) => e.message, 'message', 'gone')),
      );
    });
  });

  group('getGallery feed argument', () {
    test('passes the selected feed to scripts that declare it', () async {
      final client = MangaApiClient(code: '''
        import "manga_models";
        function getGallery(page, query, filters, feed) {
          return [buildGallery({"uid": feed, "title": query, "cover": "", "data": {}})];
        }
      ''');

      final result = await client.getGallery(page: 1, query: 'q', feed: 'latest');

      expect(result.single.uid, 'latest');
    });

    test('scripts without a feed parameter keep working', () async {
      final client = MangaApiClient(code: '''
        import "manga_models";
        function getGallery(page, query, filters) {
          return [buildGallery({"uid": "p" + page, "title": "", "cover": "", "data": {}})];
        }
      ''');

      final result = await client.getGallery(page: 2, feed: 'latest');

      expect(result.single.uid, 'p2');
    });

    test('no feed reaches the script as an empty string', () async {
      final client = MangaApiClient(code: '''
        import "manga_models";
        function getGallery(page, query, filters, feed) {
          if (feed == "") {
            return [buildGallery({"uid": "none", "title": "", "cover": "", "data": {}})];
          }
          return [];
        }
      ''');

      final result = await client.getGallery(page: 1);

      expect(result.single.uid, 'none');
    });
  });

  group('AnimeVideoSource contract', () {
    test('buildAnimeVideoSource accepts skip markers, audio label and download preference',
        () async {
      final source = await run('''
        import "anime_models";
        function main() {
          return buildAnimeVideoSource({
            "url": "https://cdn/a.m3u8",
            "audioLabel": " Studio Dub ",
            "preferForDownload": true,
            "skip": [
              {"type": "intro", "start": 10, "end": 95.5},
              {"type": "OUTRO", "start": "1300", "end": "1390"},
              {"type": "credits", "start": 1, "end": 2},
              {"type": "recap", "start": 50, "end": 40}
            ]
          });
        }
      ''') as AnimeVideoSource;

      expect(source.audioLabel, 'Studio Dub');
      expect(source.preferForDownload, isTrue);
      expect(source.skip.map((e) => e.type),
          [AnimeSkipType.intro, AnimeSkipType.outro]);
      expect(source.skip.first.end, 95.5);
      expect(source.skip.last.start, 1300);
    });

    test('skip markers drop non-finite and negative times', () {
      final source = AnimeVideoSourceReader.readSource({
        'url': 'https://x',
        'skip': [
          {'type': 'intro', 'start': double.nan, 'end': 90},
          {'type': 'intro', 'start': 0, 'end': double.infinity},
          {'type': 'intro', 'start': 'NaN', 'end': '90'},
          {'type': 'intro', 'start': '0', 'end': 'Infinity'},
          {'type': 'intro', 'start': double.negativeInfinity, 'end': 10},
          {'type': 'recap', 'start': -5, 'end': 10},
          {'type': 'outro', 'start': 1200, 'end': 1290},
        ],
      });

      expect(source.skip, hasLength(1));
      expect(source.skip.single.type, AnimeSkipType.outro);
      expect(() => jsonEncode(source.toJson()), returnsNormally);
    });

    test('sources without the new fields keep defaults', () {
      final source = AnimeVideoSourceReader.readSource({'url': 'https://x'});

      expect(source.skip, isEmpty);
      expect(source.audioLabel, isNull);
      expect(source.preferForDownload, isFalse);
    });

    test('the new fields survive a json round trip and old json still parses',
        () {
      const source = AnimeVideoSource(
        url: 'https://x',
        audioLabel: 'Dub',
        preferForDownload: true,
        skip: [AnimeSkipMarker(type: AnimeSkipType.recap, start: 0, end: 30)],
      );

      final decoded =
          AnimeVideoSource.fromJson(jsonDecode(jsonEncode(source.toJson())));
      final legacy = AnimeVideoSource.fromJson(
          {'url': 'https://x', 'headers': <String, dynamic>{}, 'subtitles': <dynamic>[]});

      expect(decoded.audioLabel, 'Dub');
      expect(decoded.preferForDownload, isTrue);
      expect(decoded.skip.single.type, AnimeSkipType.recap);
      expect(decoded.skip.single.end, 30);
      expect(legacy.skip, isEmpty);
      expect(legacy.preferForDownload, isFalse);
    });
  });
}
