import 'package:capyscript/Interpreter/capyscript_runtime_error.dart';
import 'package:capyscript/Interpreter/interpreter.dart';
import 'package:capyscript/api_clients/anime_api_client.dart';
import 'package:capyscript/api_clients/host/extension_host.dart';
import 'package:capyscript/api_clients/manga_api_client.dart';
import 'package:capyscript/api_clients/source_error.dart';
import 'package:capyscript/modules/waka_models/models/config_info/preferences/extension_preference.dart';
import 'package:test/test.dart';

class FakePreferences extends ExtensionPreferencesProvider {
  final Map<String, Object?> values;

  const FakePreferences(this.values);

  @override
  Future<Object?> getPreference(String key) async => values[key];
}

class StorageWrite {
  final String key;
  final String value;
  final Duration? ttl;

  const StorageWrite(this.key, this.value, this.ttl);
}

class FakeStorage extends ExtensionStorage {
  final Map<String, String> entries = {};
  final List<StorageWrite> writes = [];
  final List<String> removals = [];

  @override
  Future<String?> read(String key) async => entries[key];

  @override
  Future<void> write(String key, String value, {Duration? ttl}) async {
    writes.add(StorageWrite(key, value, ttl));
    entries[key] = value;
  }

  @override
  Future<void> remove(String key) async {
    removals.add(key);
    entries.remove(key);
  }
}

const List<ExtensionPreference> declaredPreferences = [
  ExtensionPreference(
    key: 'lang',
    type: ExtensionPreferenceType.select,
    title: 'Language',
    defaultValue: 'en',
    options: [
      ExtensionPreferenceOption(value: 'en', label: 'English'),
      ExtensionPreferenceOption(value: 'uk', label: 'Ukrainian'),
    ],
  ),
  ExtensionPreference(
    key: 'adult',
    type: ExtensionPreferenceType.toggle,
    title: 'Adult',
    defaultValue: true,
  ),
  ExtensionPreference(
    key: 'pageSize',
    type: ExtensionPreferenceType.number,
    title: 'Page size',
    defaultValue: 20,
  ),
  ExtensionPreference(
    key: 'genres',
    type: ExtensionPreferenceType.multiselect,
    title: 'Genres',
    defaultValue: ['action'],
    options: [
      ExtensionPreferenceOption(value: 'action', label: 'Action'),
      ExtensionPreferenceOption(value: 'drama', label: 'Drama'),
    ],
  ),
];

Future<dynamic> runMain(
  String source, {
  ExtensionHost host = ExtensionHost.none,
}) {
  return Interpreter(data: source, host: host).runFunction('main');
}

Matcher throwsSourceError(SourceErrorKind kind, String message) {
  return throwsA(
    isA<SourceError>()
        .having((error) => error.kind, 'kind', kind)
        .having((error) => error.message, 'message', message),
  );
}

void main() {
  group('preferences module', () {
    test('returns declared defaults when nothing is stored', () async {
      const host = ExtensionHost(preferenceDefinitions: declaredPreferences);

      final result = await runMain('''
        import "preferences";
        function main() {
          return [getPreference("lang"), getPreference("adult"),
            getPreference("pageSize"), getPreference("genres")];
        }
      ''', host: host);

      expect(result, [
        'en',
        true,
        20,
        ['action'],
      ]);
    });

    test('stored values win over defaults, including false', () async {
      const host = ExtensionHost(
        preferenceDefinitions: declaredPreferences,
        preferences: FakePreferences({
          'lang': 'uk',
          'adult': false,
          'pageSize': 50,
          'genres': ['action', 'drama'],
        }),
      );

      final result = await runMain('''
        import "preferences";
        function main() {
          return [getPreference("lang"), getPreference("adult"),
            getPreference("pageSize"), getPreference("genres")];
        }
      ''', host: host);

      expect(result, [
        'uk',
        false,
        50,
        ['action', 'drama'],
      ]);
    });

    test('list values behave like script lists', () async {
      const host = ExtensionHost(
        preferenceDefinitions: declaredPreferences,
        preferences: FakePreferences({
          'genres': ['drama'],
        }),
      );

      final result = await runMain('''
        import "preferences";
        function main() {
          var genres = getPreference("genres");
          genres.push("comedy");
          return genres.join(",");
        }
      ''', host: host);

      expect(result, 'drama,comedy');
    });

    test('an undeclared and unstored key is null', () async {
      const host = ExtensionHost(preferenceDefinitions: declaredPreferences);

      final result = await runMain('''
        import "preferences";
        function main() {
          return getPreference("missing") == null;
        }
      ''', host: host);

      expect(result, isTrue);
    });
  });

  group('storage module', () {
    test('round trips maps, lists, numbers, strings, bools and null', () async {
      final storage = FakeStorage();

      final result = await runMain('''
        import "storage";
        function main() {
          storageSet("map", {"a": [1, 2.5, null, true], "b": {"c": "x"}});
          storageSet("list", [1, "two", [3]]);
          storageSet("int", 42);
          storageSet("float", 1.25);
          storageSet("string", "hello");
          storageSet("bool", false);
          storageSet("null", null);
          return [storageGet("map"), storageGet("list"), storageGet("int"),
            storageGet("float"), storageGet("string"), storageGet("bool"),
            storageGet("null")];
        }
      ''', host: ExtensionHost(storage: storage));

      expect(result, [
        {
          'a': [1, 2.5, null, true],
          'b': {'c': 'x'},
        },
        [
          1,
          'two',
          [3],
        ],
        42,
        1.25,
        'hello',
        false,
        null,
      ]);
      expect(storage.entries['null'], 'null');
      expect(storage.entries['string'], '"hello"');
    });

    test('decoded maps can be read and modified by the script', () async {
      final storage = FakeStorage();

      final result = await runMain('''
        import "storage";
        function main() {
          storageSet("token", {"value": "abc", "uses": 1});
          var token = storageGet("token");
          token["uses"] = token["uses"] + 1;
          storageSet("token", token);
          return storageGet("token")["uses"];
        }
      ''', host: ExtensionHost(storage: storage));

      expect(result, 2);
    });

    test('a missing key reads as null', () async {
      final result = await runMain('''
        import "storage";
        function main() {
          return storageGet("nothing") == null;
        }
      ''', host: ExtensionHost(storage: FakeStorage()));

      expect(result, isTrue);
    });

    test('ttlSeconds is forwarded to the host', () async {
      final storage = FakeStorage();

      await runMain('''
        import "storage";
        function main() {
          storageSet("forever", 1);
          storageSet("minute", 2, 60);
          storageSet("fraction", 3, 1.5);
          storageSet("explicitNull", 4, null);
          storageSet({"key": "named", "value": 5, "ttlSeconds": 10});
        }
      ''', host: ExtensionHost(storage: storage));

      expect(storage.writes.map((write) => write.key), [
        'forever',
        'minute',
        'fraction',
        'explicitNull',
        'named',
      ]);
      expect(storage.writes.map((write) => write.ttl), [
        null,
        const Duration(seconds: 60),
        const Duration(milliseconds: 1500),
        null,
        const Duration(seconds: 10),
      ]);
      expect(storage.entries['named'], '5');
    });

    test('invalid ttlSeconds is a script error', () async {
      for (final ttl in ['0', '-5', '"soon"']) {
        final storage = FakeStorage();
        await expectLater(
          runMain('''
            import "storage";
            function main() {
              storageSet("key", 1, $ttl);
            }
          ''', host: ExtensionHost(storage: storage)),
          throwsA(
            isA<CapyScriptRuntimeError>().having(
              (error) => error.message,
              'message',
              contains('ttlSeconds'),
            ),
          ),
        );
        expect(storage.writes, isEmpty);
      }
    });

    test('storageRemove deletes the key', () async {
      final storage = FakeStorage();

      final result = await runMain('''
        import "storage";
        function main() {
          storageSet("key", "value");
          storageRemove("key");
          return storageGet("key") == null;
        }
      ''', host: ExtensionHost(storage: storage));

      expect(result, isTrue);
      expect(storage.removals, ['key']);
      expect(storage.entries, isEmpty);
    });

    test('non JSON-encodable values are rejected with a clear error', () async {
      final storage = FakeStorage();

      await expectLater(
        runMain('''
          import "storage";
          function main() {
            storageSet("key", {"callback": function(x) { return x; }});
          }
        ''', host: ExtensionHost(storage: storage)),
        throwsA(
          isA<CapyScriptRuntimeError>()
              .having(
                (error) => error.message,
                'message',
                contains('not JSON-encodable'),
              )
              .having(
                (error) => error.message,
                'message',
                contains('value["callback"]'),
              ),
        ),
      );

      await expectLater(
        runMain('''
          import "storage";
          class Box {
            value;
            function constructor(v) {
              this.value = v;
            }
          }
          function main() {
            storageSet("key", [new Box(1)]);
          }
        ''', host: ExtensionHost(storage: storage)),
        throwsA(
          isA<CapyScriptRuntimeError>().having(
            (error) => error.message,
            'message',
            contains('value[0]'),
          ),
        ),
      );

      expect(storage.writes, isEmpty);
    });

    test('a corrupt stored value reads as null', () async {
      final storage = FakeStorage()..entries['key'] = '{not json';

      final result = await runMain('''
        import "storage";
        function main() {
          return storageGet("key") == null;
        }
      ''', host: ExtensionHost(storage: storage));

      expect(result, isTrue);
    });

    test(
      'two interpreters with different hosts do not share storage',
      () async {
        final firstStorage = FakeStorage();
        final secondStorage = FakeStorage();
        const source = '''
        import "storage";
        function save(value) {
          storageSet("shared", value);
        }
        function load() {
          return storageGet("shared");
        }
      ''';
        final first = Interpreter(
          data: source,
          host: ExtensionHost(storage: firstStorage),
        );
        final second = Interpreter(
          data: source,
          host: ExtensionHost(storage: secondStorage),
        );

        await first.runFunction('save', arguments: {'value': 'first'});

        expect(await first.runFunction('load'), 'first');
        expect(await second.runFunction('load'), isNull);

        await second.runFunction('save', arguments: {'value': 'second'});

        expect(await first.runFunction('load'), 'first');
        expect(await second.runFunction('load'), 'second');
        expect(firstStorage.entries['shared'], '"first"');
        expect(secondStorage.entries['shared'], '"second"');
      },
    );
  });

  group('interpreters without a host', () {
    test('preferences are null and storage is empty', () async {
      final result = await runMain('''
        import "preferences";
        import "storage";
        function main() {
          storageSet("key", {"a": 1}, 30);
          storageRemove("other");
          return [getPreference("lang"), storageGet("key")];
        }
      ''');

      expect(result, [null, null]);
    });
  });

  group('errors module', () {
    test('every kind reaches the host as a typed source error', () async {
      for (final kind in SourceErrorKind.values) {
        await expectLater(
          runMain('''
            import "errors";
            function main() {
              throwSourceError("${kind.name}", "failed ${kind.name}");
            }
          '''),
          throwsSourceError(kind, 'failed ${kind.name}'),
        );
      }
    });

    test('the message is optional', () async {
      await expectLater(
        runMain('''
          import "errors";
          function main() {
            throwSourceError("sourceDown");
          }
        '''),
        throwsSourceError(SourceErrorKind.sourceDown, ''),
      );
    });

    test(
      'an unknown kind is a plain script error naming the valid kinds',
      () async {
        final future = runMain('''
        import "errors";
        function main() {
          throwSourceError("teapot", "nope");
        }
      ''');

        await expectLater(
          future,
          throwsA(
            isA<CapyScriptRuntimeError>()
                .having((error) => error.message, 'message', contains('teapot'))
                .having(
                  (error) => error.message,
                  'message',
                  contains(
                    SourceErrorKind.values.map((kind) => kind.name).join(', '),
                  ),
                ),
          ),
        );
      },
    );

    test('a non-string kind is a plain script error', () async {
      await expectLater(
        runMain('''
          import "errors";
          function main() {
            throwSourceError(3);
          }
        '''),
        throwsA(
          isA<CapyScriptRuntimeError>().having(
            (error) => error.message,
            'message',
            contains('unknown kind'),
          ),
        ),
      );
    });

    test(
      'propagates through functions, lambdas, class methods and list callbacks',
      () async {
        await expectLater(
          runMain('''
          import "errors";
          class Fetcher {
            kind;
            function constructor(kind) {
              this.kind = kind;
            }
            function load(id) {
              var fail = function(reason) {
                throwSourceError(this.kind, reason + " " + id);
              };
              fail("missing");
            }
          }
          function fetchAll(ids) {
            var fetcher = new Fetcher("notFound");
            return ids.map(function(id) {
              return fetcher.load(id);
            });
          }
          function main() {
            return fetchAll(["a", "b"]);
          }
        '''),
          throwsSourceError(SourceErrorKind.notFound, 'missing a'),
        );
      },
    );

    test('script catch receives the message', () async {
      final result = await runMain('''
        import "errors";
        function failing() {
          throwSourceError("rateLimited", "slow down");
        }
        function main() {
          try {
            failing();
          } catch (e) {
            return e;
          }
        }
      ''');

      expect(result, 'slow down');
    });

    test(
      'script catch receives the kind name when the message is empty',
      () async {
        final result = await runMain('''
        import "errors";
        function main() {
          try {
            throwSourceError("regionBlocked");
          } catch (e) {
            return e;
          }
        }
      ''');

        expect(result, 'regionBlocked');
      },
    );

    test(
      'catching drops the kind unless the script throws a source error again',
      () async {
        await expectLater(
          runMain('''
          import "errors";
          function main() {
            try {
              throwSourceError("loginRequired", "sign in");
            } catch (e) {
              throw e;
            }
          }
        '''),
          throwsA(
            isA<CapyScriptRuntimeError>().having(
              (error) => error.message,
              'message',
              'sign in',
            ),
          ),
        );

        await expectLater(
          runMain('''
          import "errors";
          function main() {
            try {
              throwSourceError("loginRequired", "sign in");
            } catch (e) {
              throwSourceError("loginRequired", e);
            }
          }
        '''),
          throwsSourceError(SourceErrorKind.loginRequired, 'sign in'),
        );
      },
    );

    test(
      'a rethrown source error still runs finally before reaching the host',
      () async {
        final storage = FakeStorage();

        await expectLater(
          runMain('''
          import "errors";
          import "storage";
          function main() {
            try {
              throwSourceError("sourceDown", "offline");
            } catch (e) {
              throwSourceError("sourceDown", e);
            } finally {
              storageSet("cleanedUp", true);
            }
          }
        ''', host: ExtensionHost(storage: storage)),
          throwsSourceError(SourceErrorKind.sourceDown, 'offline'),
        );
        expect(storage.entries['cleanedUp'], 'true');
      },
    );
  });

  group('api clients', () {
    test(
      'MangaApiClient surfaces source errors from nested script calls',
      () async {
        final client = MangaApiClient(
          code: '''
        import "errors";
        import "manga_models";
        function requireLogin(data) {
          if (data["token"] == null) {
            throwSourceError("loginRequired", "log in to read");
          }
        }
        function getConcrete(uid, data) {
          var check = function() {
            requireLogin(data);
          };
          check();
        }
        function getPages(uid, data) {
          throwSourceError("notFound", "chapter " + uid + " removed");
        }
      ''',
        );

        await expectLater(
          client.getConcrete(uid: 'x', data: {}),
          throwsSourceError(SourceErrorKind.loginRequired, 'log in to read'),
        );
        await expectLater(
          client.getPages(uid: '7', data: {}),
          throwsSourceError(SourceErrorKind.notFound, 'chapter 7 removed'),
        );
      },
    );

    test('AnimeApiClient surfaces source errors from class methods', () async {
      final client = AnimeApiClient(
        code: '''
        import "errors";
        class Api {
          function constructor() {}
          function gallery(page) {
            if (page > 1) {
              throwSourceError("rateLimited", "too many pages");
            }
            return [];
          }
        }
        function getGallery(page, query, filters) {
          return new Api().gallery(page);
        }
      ''',
      );

      expect(await client.getGallery(page: 1), isEmpty);
      await expectLater(
        client.getGallery(page: 2),
        throwsSourceError(SourceErrorKind.rateLimited, 'too many pages'),
      );
    });

    test('api clients pass their host to preferences and storage', () async {
      final storage = FakeStorage();
      final client = MangaApiClient(
        code: '''
          import "manga_models";
          import "preferences";
          import "storage";
          function getGallery(page, query, filters) {
            var lang = getPreference("lang");
            storageSet("lastPage", page, 120);
            return [buildGallery({"uid": lang + page, "title": "", "cover": "", "data": {}})];
          }
        ''',
        host: ExtensionHost(
          extensionUid: 'manga',
          preferenceDefinitions: declaredPreferences,
          preferences: const FakePreferences({'lang': 'uk'}),
          storage: storage,
        ),
      );

      final result = await client.getGallery(page: 3);

      expect(result.single.uid, 'uk3');
      expect(storage.entries['lastPage'], '3');
      expect(storage.writes.single.ttl, const Duration(seconds: 120));
    });
  });
}
