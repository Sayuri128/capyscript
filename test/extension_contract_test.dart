import 'dart:convert';

import 'package:capyscript/Interpreter/interpreter.dart';
import 'package:capyscript/api_clients/host/extension_host.dart';
import 'package:capyscript/api_clients/manga_api_client.dart';
import 'package:capyscript/api_clients/novel_api_client.dart';
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
import 'package:capyscript/modules/waka_models/models/config_info/request_policy/request_policy.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_concrete_view/manga_concrete_view.dart';
import 'package:capyscript/modules/waka_models/models/novel/novel_chapter_content.dart';
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

  group('ConfigInfo leniency', () {
    ConfigInfo parseWith(Map<String, dynamic> fields) {
      return ConfigInfo.fromJson(_baseConfig()..addAll(fields));
    }

    test('drops malformed preferences and keeps the valid ones', () {
      final config = parseWith(<String, dynamic>{
        'preferences': <dynamic>[
          {'key': 'noTitle', 'type': 'toggle'},
          {'key': 'numberTitle', 'type': 'toggle', 'title': 5},
          {'type': 'toggle', 'title': 'No key'},
          {'key': 'unknown', 'type': 'slider', 'title': 'Unknown'},
          'not a map',
          null,
          {
            'key': 'oddSummary',
            'type': 'text',
            'title': 'Odd summary',
            'summary': ['not', 'text'],
          },
          {
            'key': 'oddOptions',
            'type': 'select',
            'title': 'Odd options',
            'options': {'value': 'a', 'label': 'A'},
          },
          {'key': 'adult', 'type': 'toggle', 'title': 'Adult'},
        ],
      });

      expect(
        config.preferences.map((e) => e.key),
        ['oddSummary', 'oddOptions', 'adult'],
      );
      expect(config.preferences.first.summary, isNull);
      expect(config.preferences[1].options, isEmpty);
    });

    test('drops malformed options and coerces scalar values to strings', () {
      final config = parseWith(<String, dynamic>{
        'preferences': <dynamic>[
          {
            'key': 'quality',
            'type': 'select',
            'title': 'Quality',
            'options': <dynamic>[
              {'value': 1, 'label': 'One'},
              {'value': 'two', 'label': 2.5},
              {'value': true, 'label': 'Yes'},
              {'value': 'missing label'},
              {'label': 'missing value'},
              {'value': ['a'], 'label': 'List value'},
              {'value': 'x', 'label': {'nested': true}},
              'plain',
              {'value': 'ok', 'label': 'Ok'},
            ],
          },
        ],
      });

      final options = config.preferences.single.options;
      expect(options.map((e) => e.value), ['1', 'two', 'true', 'ok']);
      expect(options.map((e) => e.label), ['One', '2.5', 'Yes', 'Ok']);
    });

    test('a malformed rate limit is absent and the rest of the policy stays', () {
      for (final rateLimit in <Object?>[
        {'requests': 4},
        {'perSeconds': 1},
        {'requests': '4', 'perSeconds': 1},
        {'requests': 0, 'perSeconds': 1},
        {'requests': 4, 'perSeconds': 0},
        {'requests': 4, 'perSeconds': -1},
        'fast',
        <dynamic>[4, 1],
      ]) {
        final config = parseWith(<String, dynamic>{
          'requestPolicy': {
            'rateLimit': rateLimit,
            'userAgent': 'UA',
          },
        });

        expect(config.requestPolicy, isNotNull, reason: '$rateLimit');
        expect(config.requestPolicy!.rateLimit, isNull, reason: '$rateLimit');
        expect(config.requestPolicy!.userAgent, 'UA');
      }
    });

    test('a rate limit with a huge window is capped at a day', () {
      final config = parseWith(<String, dynamic>{
        'requestPolicy': {
          'rateLimit': {'requests': 1, 'perSeconds': 1e300},
        },
      });

      expect(config.requestPolicy!.rateLimit!.window, RateLimit.maxWindow);
    });

    test('a request policy that is not a map is absent', () {
      for (final policy in <Object?>['strict', 1, <dynamic>[], true]) {
        expect(
          parseWith(<String, dynamic>{'requestPolicy': policy}).requestPolicy,
          isNull,
        );
      }
    });

    test('drops malformed headers and mirrors and ignores a non-string agent', () {
      final config = parseWith(<String, dynamic>{
        'requestPolicy': {
          'defaultHeaders': {
            'Referer': 'https://example.org',
            'X-Count': 1,
            'X-Null': null,
            'X-List': ['a'],
          },
          'userAgent': 42,
          'mirrors': ['https://a.example', 5, null, {'url': 'x'}, 'https://b.example'],
        },
      });
      final policy = config.requestPolicy!;

      expect(policy.defaultHeaders, {'Referer': 'https://example.org'});
      expect(policy.userAgent, isNull);
      expect(policy.mirrors, ['https://a.example', 'https://b.example']);
    });

    test('headers and mirrors of the wrong shape become empty', () {
      final config = parseWith(<String, dynamic>{
        'requestPolicy': {
          'defaultHeaders': ['Referer'],
          'mirrors': 'https://a.example',
        },
      });

      expect(config.requestPolicy!.defaultHeaders, isEmpty);
      expect(config.requestPolicy!.mirrors, isEmpty);
    });

    test('drops feeds whose id or title are not strings', () {
      final config = parseWith(<String, dynamic>{
        'feeds': <dynamic>[
          {'id': 1, 'title': 'Numeric id'},
          {'id': 'popular', 'title': null},
          {'id': 'latest', 'title': 'Latest'},
          'popular',
        ],
      });

      expect(config.feeds.map((e) => e.id), ['latest']);
    });

    test('collections of the wrong shape become empty', () {
      final config = parseWith(<String, dynamic>{
        'preferences': {'key': 'lang'},
        'feeds': 'popular',
      });

      expect(config.preferences, isEmpty);
      expect(config.feeds, isEmpty);
    });

    test('an unknown type is a format error', () {
      for (final type in <Object?>[3, -1, 'manga', null, 0.5]) {
        expect(
          () => parseWith(<String, dynamic>{'type': type}),
          throwsA(
            isA<FormatException>().having(
              (error) => error.message,
              'message',
              contains('$type'),
            ),
          ),
          reason: '$type',
        );
      }
      expect(parseWith(<String, dynamic>{'type': 1}).type, ConfigInfoType.ANIME);
      expect(
        ConfigInfo.fromJson(
          jsonDecode(jsonEncode(parseWith(<String, dynamic>{'type': 1}).toJson())),
        ).type,
        ConfigInfoType.ANIME,
      );
    });

    test('type 2 is a novel and survives a json round trip', () {
      final config = parseWith(<String, dynamic>{'type': 2});

      expect(config.type, ConfigInfoType.NOVEL);
      expect(config.toJson()['type'], 2);
      expect(
        ConfigInfo.fromJson(jsonDecode(jsonEncode(config.toJson()))).type,
        ConfigInfoType.NOVEL,
      );
    });

    test('skip markers from json drop malformed entries', () {
      final source = AnimeVideoSource.fromJson(<String, dynamic>{
        'url': 'https://x',
        'skip': <dynamic>[
          {'type': 'intro', 'start': 0, 'end': 90},
          {'type': 'intro', 'start': '0', 'end': 90},
          {'type': 'credits', 'start': 0, 'end': 90},
          {'type': 'outro', 'start': -1, 'end': 90},
          {'type': 'outro', 'start': 10, 'end': double.infinity},
          {'type': 'recap', 'start': 50, 'end': 40},
          'intro',
        ],
      });
      final notAList = AnimeVideoSource.fromJson(<String, dynamic>{
        'url': 'https://x',
        'skip': {'type': 'intro', 'start': 0, 'end': 90},
      });

      expect(source.skip, hasLength(1));
      expect(source.skip.single.end, 90);
      expect(notAList.skip, isEmpty);
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

  group('multi instance', () {
    test('only a literal true enables multiple instances', () {
      expect(ConfigInfo.fromJson(_baseConfig()).multiInstance, isFalse);
      expect(
        ConfigInfo.fromJson(<String, dynamic>{..._baseConfig(), 'multiInstance': true})
            .multiInstance,
        isTrue,
      );
      expect(
        ConfigInfo.fromJson(<String, dynamic>{..._baseConfig(), 'multiInstance': 'yes'})
            .multiInstance,
        isFalse,
      );
      final config = ConfigInfo.fromJson(<String, dynamic>{..._baseConfig(), 'multiInstance': true});
      expect(ConfigInfo.fromJson(jsonDecode(jsonEncode(config.toJson()))).multiInstance, isTrue);
    });
  });

  group('secret preferences', () {
    test('text preferences can be marked secret, other types cannot', () {
      final config = ConfigInfo.fromJson(<String, dynamic>{
        ..._baseConfig(),
        'apiVersion': 2,
        'preferences': <dynamic>[
          {'key': 'password', 'type': 'text', 'title': 'Password', 'secret': true},
          {'key': 'on', 'type': 'toggle', 'title': 'On', 'secret': true},
          {'key': 'name', 'type': 'text', 'title': 'Name'},
        ],
      });

      expect(config.preferences.map((p) => p.secret), <bool>[true, false, false]);
      final decoded = ConfigInfo.fromJson(jsonDecode(jsonEncode(config.toJson())));
      expect(decoded.preferences.first.secret, isTrue);
    });
  });

  group('getImageHeaders', () {
    test('a script without getImageHeaders gets no headers', () async {
      final client = MangaApiClient(code: '''
        import "manga_models";
        function getGallery(page, query, filters) {
          return [];
        }
      ''');

      expect(await client.getImageHeaders(uid: 'a', data: {}), isEmpty);
    });
  });

  group('getRelated', () {
    test('returns related titles from scripts that define it', () async {
      final client = MangaApiClient(code: '''
        import "manga_models";
        function getRelated(uid, data) {
          return [buildGallery({"uid": uid + "-related", "title": data["t"], "cover": "", "data": {}})];
        }
      ''');

      expect(await client.supportsRelated(), isTrue);
      final result = await client.getRelated(uid: 'a', data: {'t': 'Other'});

      expect(result.single.uid, 'a-related');
      expect(result.single.title, 'Other');
    });

    test('scripts without getRelated report no support', () async {
      final client = MangaApiClient(code: '''
        import "manga_models";
        function getGallery(page, query, filters) {
          return [];
        }
      ''');

      expect(await client.supportsRelated(), isFalse);
    });
  });

  group('NovelApiClient', () {
    const novelScript = '''
      import "novel_models";
      function getGallery(page, query, filters, feed) {
        return [buildGallery({"uid": "n" + page, "title": query, "cover": "c", "data": {"feed": feed}})];
      }
      function getConcrete(uid, data) {
        return buildConcrete({
          "uid": uid,
          "cover": "",
          "title": "Novel",
          "description": "",
          "tags": ["fantasy"],
          "groups": [buildChapterGroups({"title": "Volume 1", "elements": [
            buildChapter({"uid": "c1", "title": "One", "timestamp": null, "data": {"id": 1}, "number": 1}),
            buildChapter({"uid": "c2", "title": "Two", "timestamp": null, "data": {"id": 2}, "number": 2})
          ]})],
          "status": statusOngoing(),
          "alternativeTitles": []
        });
      }
      function getRelated(uid, data) {
        return [buildGallery({"uid": uid + "-sequel", "title": "Sequel", "cover": "", "data": {}})];
      }
      function getChapterText(uid, data) {
        return buildNovelChapter({"title": "Chapter " + data["id"], "html": "<p>" + uid + "</p>"});
      }
    ''';

    test('gallery, concrete and related use the manga models', () async {
      final client = NovelApiClient(code: novelScript);

      final gallery = await client.getGallery(page: 3, query: 'q', feed: 'top');
      final concrete = await client.getConcrete(uid: 'n1', data: {});
      final related = await client.getRelated(uid: 'n1', data: {});

      expect(gallery.single.uid, 'n3');
      expect(gallery.single.title, 'q');
      expect(gallery.single.data['feed'], 'top');
      expect(concrete, isA<MangaConcreteView>());
      expect(concrete.groups.single.elements.map((e) => e.uid), ['c1', 'c2']);
      expect(concrete.groups.single.elements.last.number, 2);
      expect(related.single.uid, 'n1-sequel');
    });

    test('getChapterText returns the built chapter', () async {
      final client = NovelApiClient(code: novelScript);

      final chapter = await client.getChapterText(uid: 'c2', data: {'id': 2});

      expect(chapter.title, 'Chapter 2');
      expect(chapter.html, '<p>c2</p>');
    });

    test('buildNovelChapter title is optional', () async {
      final client = NovelApiClient(code: '''
        import "novel_models";
        function getChapterText(uid, data) {
          return buildNovelChapter({"html": "plain text"});
        }
      ''');

      final chapter = await client.getChapterText(uid: 'c', data: {});

      expect(chapter.title, '');
      expect(chapter.html, 'plain text');
    });

    test('a plain string or map result is accepted', () async {
      final fromString = NovelApiClient(code: '''
        function getChapterText(uid, data) {
          return "<p>raw</p>";
        }
      ''');
      final fromMap = NovelApiClient(code: '''
        function getChapterText(uid, data) {
          return {"title": "T", "html": "<p>map</p>"};
        }
      ''');

      expect((await fromString.getChapterText(uid: 'c', data: {})).html, '<p>raw</p>');
      final mapChapter = await fromMap.getChapterText(uid: 'c', data: {});
      expect(mapChapter.title, 'T');
      expect(mapChapter.html, '<p>map</p>');
    });

    test('getImageHeaders is optional for novels', () async {
      final client = NovelApiClient(code: '''
        function getChapterText(uid, data) {
          return "text";
        }
      ''');
      final withHeaders = NovelApiClient(code: '''
        function getImageHeaders(uid, data) {
          return {"Referer": "https://example.org"};
        }
      ''');

      expect(await client.getImageHeaders(uid: 'n', data: {}), isEmpty);
      expect(
        await withHeaders.getImageHeaders(uid: 'n', data: {}),
        {'Referer': 'https://example.org'},
      );
    });

    test('any other result is a format error', () {
      expect(() => NovelApiClient.readChapterContent(42), throwsFormatException);
      expect(() => NovelApiClient.readChapterContent(null), throwsFormatException);
    });

    test('chapter content survives a json round trip', () {
      const content = NovelChapterContent(title: 'T', html: '<p>x</p>');

      final decoded = NovelChapterContent.fromJson(jsonDecode(jsonEncode(content.toJson())));

      expect(decoded.title, 'T');
      expect(decoded.html, '<p>x</p>');
      expect(content.getField('html'), '<p>x</p>');
    });
  });

  group('content kinds and protector timeout', () {
    test('content kinds are normalised and deduplicated', () {
      final config = ConfigInfo.fromJson(<String, dynamic>{
        ..._baseConfig(),
        'contentKinds': <dynamic>[' Movie', 'series', 'movie', 3, ''],
      });

      expect(config.contentKinds, <String>['movie', 'series']);
      expect(ConfigInfo.fromJson(_baseConfig()).contentKinds, isEmpty);
      expect(
        ConfigInfo.fromJson(<String, dynamic>{..._baseConfig(), 'contentKinds': 'anime'})
            .contentKinds,
        isEmpty,
      );
    });

    test('content kinds survive a json round trip', () {
      final config = ConfigInfo.fromJson(<String, dynamic>{
        ..._baseConfig(),
        'contentKinds': <dynamic>['anime'],
      });

      expect(
        ConfigInfo.fromJson(jsonDecode(jsonEncode(config.toJson()))).contentKinds,
        <String>['anime'],
      );
    });

    test('the page load timeout is kept only inside its range', () {
      Map<String, dynamic> protector(Object? seconds) => <String, dynamic>{
            ..._baseConfig(),
            'protectorConfig': <String, dynamic>{
              'pingUrl': 'https://x',
              'needToLogin': false,
              'inAppBrowserInterceptor': true,
              'pageLoadTimeoutSeconds': seconds,
            },
          };

      expect(ConfigInfo.fromJson(protector(45)).protectorConfig?.pageLoadTimeoutSeconds, 45);
      expect(ConfigInfo.fromJson(protector(2)).protectorConfig?.pageLoadTimeoutSeconds, isNull);
      expect(ConfigInfo.fromJson(protector('45')).protectorConfig?.pageLoadTimeoutSeconds, isNull);
      expect(ConfigInfo.fromJson(protector(null)).protectorConfig?.pageLoadTimeoutSeconds, isNull);
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
