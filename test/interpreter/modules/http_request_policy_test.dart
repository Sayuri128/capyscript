import 'dart:convert';
import 'dart:io';

import 'package:capyscript/Interpreter/interpreter.dart';
import 'package:capyscript/api_clients/host/extension_host.dart';
import 'package:capyscript/modules/http/http_interceptor_controller.dart';
import 'package:capyscript/modules/http/http_module.dart';
import 'package:capyscript/modules/http/http_utils.dart';
import 'package:capyscript/modules/http/policy/http_clock.dart';
import 'package:capyscript/modules/http/policy/http_rate_limiter.dart';
import 'package:capyscript/modules/http/policy/http_request_policy_enforcer.dart';
import 'package:capyscript/modules/http/policy/http_request_state.dart';
import 'package:capyscript/modules/waka_models/models/config_info/request_policy/request_policy.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';

const String _script = '''
import "http";

function fetch(url, headers) {
    var response = httpGet({"url": url, "headers": headers});
    return {"status": response.statusCode, "body": response.body};
}

function send(url, body) {
    var response = httpPost({"url": url, "body": body});
    return {"status": response.statusCode, "body": response.body};
}

function fetchThroughWeb(url) {
    var response = httpGet({"url": url, "throughWeb": true});
    return {"status": response.statusCode, "body": response.body};
}

function useSessionHeaders(headers) {
    useHeaders({"headers": headers});
    return getHeaders();
}

function sessionHeaders() {
    return getHeaders();
}

function mirror() {
    return currentMirror();
}

function setController(controller) {
    registerInterceptorController(controller);
    return true;
}
''';

class _FakeClock extends HttpClock {
  Duration current = Duration.zero;
  final List<Duration> waits = <Duration>[];

  @override
  Duration now() => current;

  @override
  Future<void> wait(Duration duration) async {
    waits.add(duration);
    current += duration;
  }
}

class _TestSite {
  final String name;
  final HttpServer server;
  int statusCode = 200;
  final List<Map<String, String>> receivedHeaders = <Map<String, String>>[];
  final List<String> receivedPaths = <String>[];
  final List<String> receivedBodies = <String>[];

  _TestSite._(this.name, this.server) {
    server.listen(_handle);
  }

  static Future<_TestSite> start(String name) async {
    final HttpServer server = await HttpServer.bind(
      InternetAddress.loopbackIPv4,
      0,
    );
    return _TestSite._(name, server);
  }

  String get base => 'http://127.0.0.1:${server.port}';

  int get hits => receivedPaths.length;

  Future<void> _handle(HttpRequest request) async {
    final Map<String, String> headers = <String, String>{};
    request.headers.forEach((String headerName, List<String> values) {
      headers[headerName] = values.join(',');
    });
    receivedHeaders.add(headers);
    receivedPaths.add(request.uri.toString());
    receivedBodies.add(await utf8.decoder.bind(request).join());
    request.response.statusCode = statusCode;
    request.response.headers.contentType = ContentType.json;
    request.response.write(
      jsonEncode(<String, dynamic>{
        'site': name,
        'path': request.uri.path,
        'headers': headers,
      }),
    );
    await request.response.close();
  }

  Future<void> close() => server.close(force: true);
}

class _FixedPreferences extends ExtensionPreferencesProvider {
  final Map<String, Object?> values;

  const _FixedPreferences(this.values);

  @override
  Future<Object?> getPreference(String key) async => values[key];
}

class _RecordingController extends HttpInterceptorController {
  final List<String> loadedUrls = <String>[];
  final List<Map<String, String>> loadedHeaders = <Map<String, String>>[];
  int statusCode = 503;

  @override
  Future<HttpInterceptorControllerResponse> loadPage({
    required String url,
    String? method,
    Map<String, String>? headers,
    String? body,
  }) async {
    loadedUrls.add(url);
    loadedHeaders.add(headers ?? <String, String>{});
    return HttpInterceptorControllerResponse(
      body: 'web',
      data: <String, dynamic>{},
      statusCode: statusCode,
      headers: <String, String>{},
      cookies: <String, String>{},
    );
  }

  @override
  Future<dynamic> executeJsScript(String code) async => null;
}

int _uidCounter = 0;

String _uniqueUid(String label) => 'policy-test-$label-${_uidCounter++}';

Interpreter _interpreter({
  String? uid,
  RequestPolicy? policy,
  Map<String, Object?> preferences = const <String, Object?>{},
}) {
  return Interpreter(
    data: _script,
    host: ExtensionHost(
      extensionUid: uid,
      requestPolicy: policy,
      preferences: _FixedPreferences(preferences),
    ),
  );
}

Future<Map<String, dynamic>> _fetch(
  Interpreter interpreter,
  String url, {
  Map<String, String> headers = const <String, String>{},
}) async {
  final Map<dynamic, dynamic> result =
      await interpreter.runFunction(
            'fetch',
            arguments: <String, dynamic>{'url': url, 'headers': headers},
          )
          as Map;
  return <String, dynamic>{
    'status': result['status'],
    'body': jsonDecode(result['body'] as String),
  };
}

Future<ServerSocket> _droppingServer() async {
  final ServerSocket socket = await ServerSocket.bind(
    InternetAddress.loopbackIPv4,
    0,
  );
  socket.listen((Socket connection) => connection.destroy());
  return socket;
}

class _SilentServer {
  final ServerSocket socket;
  final List<Socket> heldConnections = <Socket>[];

  _SilentServer._(this.socket) {
    socket.listen(heldConnections.add);
  }

  static Future<_SilentServer> start() async {
    return _SilentServer._(
      await ServerSocket.bind(InternetAddress.loopbackIPv4, 0),
    );
  }

  String get base => 'http://127.0.0.1:${socket.port}';

  Future<void> close() async {
    for (final Socket connection in heldConnections) {
      connection.destroy();
    }
    await socket.close();
  }
}

Future<int> _closedPort() async {
  final ServerSocket socket = await ServerSocket.bind(
    InternetAddress.loopbackIPv4,
    0,
  );
  final int port = socket.port;
  await socket.close();
  return port;
}

void main() {
  late _TestSite siteA;
  late _TestSite siteB;
  late _TestSite siteC;
  late _FakeClock fakeClock;

  setUp(() async {
    siteA = await _TestSite.start('a');
    siteB = await _TestSite.start('b');
    siteC = await _TestSite.start('c');
    fakeClock = _FakeClock();
    HttpRequestStateRegistry.clock = fakeClock;
  });

  tearDown(() async {
    HttpRequestStateRegistry.reset();
    await siteA.close();
    await siteB.close();
    await siteC.close();
  });

  group('rate limiter', () {
    test('spaces requests over a sliding window', () async {
      final _FakeClock clock = _FakeClock();
      final HttpRateLimiter limiter = HttpRateLimiter(
        maxRequests: 2,
        window: const Duration(seconds: 1),
        clock: clock,
      );
      final List<Duration> startTimes = <Duration>[];

      await Future.wait(
        List<Future<void>>.generate(5, (_) async {
          await limiter.acquire();
          startTimes.add(clock.now());
        }),
      );

      expect(startTimes, <Duration>[
        Duration.zero,
        Duration.zero,
        const Duration(seconds: 1),
        const Duration(seconds: 1),
        const Duration(seconds: 2),
      ]);
      expect(clock.waits, <Duration>[
        const Duration(seconds: 1),
        const Duration(seconds: 1),
      ]);
    });

    test('waits in real time with the system clock', () async {
      final HttpRateLimiter limiter = HttpRateLimiter(
        maxRequests: 1,
        window: const Duration(milliseconds: 120),
      );
      final Stopwatch stopwatch = Stopwatch()..start();

      await limiter.acquire();
      await limiter.acquire();
      await limiter.acquire();

      expect(
        stopwatch.elapsed,
        greaterThanOrEqualTo(const Duration(milliseconds: 230)),
      );
    });

    test('is shared by interpreters built for the same extension', () async {
      final String uid = _uniqueUid('shared');
      const RequestPolicy policy = RequestPolicy(
        rateLimit: RateLimit(requests: 1, perSeconds: 10),
      );
      final Interpreter first = _interpreter(uid: uid, policy: policy);
      final Interpreter second = _interpreter(uid: uid, policy: policy);

      await _fetch(first, '${siteA.base}/one');
      expect(fakeClock.waits, isEmpty);

      await _fetch(second, '${siteA.base}/two');
      expect(fakeClock.waits, <Duration>[const Duration(seconds: 10)]);
      expect(siteA.hits, 2);
    });

    test('is isolated between different extensions', () async {
      const RequestPolicy policy = RequestPolicy(
        rateLimit: RateLimit(requests: 1, perSeconds: 10),
      );
      final Interpreter first = _interpreter(
        uid: _uniqueUid('isolated'),
        policy: policy,
      );
      final Interpreter second = _interpreter(
        uid: _uniqueUid('isolated'),
        policy: policy,
      );

      await _fetch(first, '${siteA.base}/one');
      await _fetch(second, '${siteA.base}/two');

      expect(fakeClock.waits, isEmpty);
    });

    test('gives interpreters without a uid a private limiter', () async {
      const RequestPolicy policy = RequestPolicy(
        rateLimit: RateLimit(requests: 1, perSeconds: 10),
      );
      final Interpreter first = _interpreter(policy: policy);
      final Interpreter second = _interpreter(policy: policy);

      await _fetch(first, '${siteA.base}/one');
      await _fetch(second, '${siteA.base}/two');
      expect(fakeClock.waits, isEmpty);

      await _fetch(first, '${siteA.base}/three');
      expect(fakeClock.waits, <Duration>[const Duration(seconds: 10)]);
    });

    test(
      'updates the limit of one owner in place and keeps its history',
      () async {
        final _FakeClock clock = _FakeClock();
        final HttpRateLimiter limiter = HttpRateLimiter.shared(clock: clock);
        final Object owner = Object();

        limiter.declare(
          owner,
          const HttpRateLimit(maxRequests: 1, window: Duration(seconds: 10)),
        );
        await limiter.acquire();
        limiter.declare(
          owner,
          const HttpRateLimit(maxRequests: 2, window: Duration(seconds: 10)),
        );
        await limiter.acquire();
        expect(clock.waits, isEmpty);

        await limiter.acquire();
        expect(clock.waits, <Duration>[const Duration(seconds: 10)]);
      },
    );

    test('enforces every live declared limit at once', () async {
      final _FakeClock clock = _FakeClock();
      final HttpRateLimiter limiter = HttpRateLimiter.shared(clock: clock);
      final Object strictOwner = Object();
      final Object burstyOwner = Object();
      limiter.declare(
        strictOwner,
        const HttpRateLimit(maxRequests: 2, window: Duration(seconds: 10)),
      );
      limiter.declare(
        burstyOwner,
        const HttpRateLimit(maxRequests: 1, window: Duration(seconds: 1)),
      );
      final List<Duration> startTimes = <Duration>[];

      await Future.wait(
        List<Future<void>>.generate(4, (_) async {
          await limiter.acquire();
          startTimes.add(clock.now());
        }),
      );

      expect(startTimes, <Duration>[
        Duration.zero,
        const Duration(seconds: 1),
        const Duration(seconds: 10),
        const Duration(seconds: 11),
      ]);
      expect(strictOwner, isNotNull);
      expect(burstyOwner, isNotNull);
    });

    test(
      'keeps one limiter per extension when cached configs disagree',
      () async {
        final String uid = _uniqueUid('disagree');
        final Interpreter strict = _interpreter(
          uid: uid,
          policy: const RequestPolicy(
            rateLimit: RateLimit(requests: 1, perSeconds: 10),
          ),
        );
        final Interpreter loose = _interpreter(
          uid: uid,
          policy: const RequestPolicy(
            rateLimit: RateLimit(requests: 5, perSeconds: 10),
          ),
        );

        await _fetch(strict, '${siteA.base}/one');
        await _fetch(loose, '${siteA.base}/two');
        await _fetch(strict, '${siteA.base}/three');

        expect(fakeClock.waits, <Duration>[
          const Duration(seconds: 10),
          const Duration(seconds: 10),
        ]);
        expect(siteA.hits, 3);
      },
    );

    test(
      'serializes concurrent waiters from clients with different limits',
      () async {
        final String uid = _uniqueUid('concurrent');
        final Interpreter strict = _interpreter(
          uid: uid,
          policy: const RequestPolicy(
            rateLimit: RateLimit(requests: 1, perSeconds: 10),
          ),
        );
        final Interpreter loose = _interpreter(
          uid: uid,
          policy: const RequestPolicy(
            rateLimit: RateLimit(requests: 4, perSeconds: 10),
          ),
        );
        await _fetch(strict, '${siteA.base}/warmup');

        await Future.wait(<Future<void>>[
          _fetch(strict, '${siteA.base}/strict'),
          _fetch(loose, '${siteA.base}/loose-one'),
          _fetch(loose, '${siteA.base}/loose-two'),
        ]);

        expect(fakeClock.current, const Duration(seconds: 30));
        expect(siteA.hits, 4);
      },
    );

    test(
      'a client without a rate limit shares the live limit of its extension',
      () async {
        final String uid = _uniqueUid('unlimited-sibling');
        final Interpreter limited = _interpreter(
          uid: uid,
          policy: const RequestPolicy(
            rateLimit: RateLimit(requests: 1, perSeconds: 10),
          ),
        );
        final Interpreter unlimited = _interpreter(
          uid: uid,
          policy: const RequestPolicy(userAgent: 'agent'),
        );

        await _fetch(limited, '${siteA.base}/one');
        await _fetch(unlimited, '${siteA.base}/two');

        expect(fakeClock.waits, <Duration>[const Duration(seconds: 10)]);
        expect(await limited.runFunction('mirror'), isNull);
      },
    );

    test('one state hands out the same limiter to every owner', () {
      final HttpExtensionRequestState state = HttpExtensionRequestState();
      final HttpRateLimiter? first = state.rateLimiterFor(
        owner: Object(),
        rateLimit: const RateLimit(requests: 1, perSeconds: 1),
        clock: fakeClock,
      );
      final HttpRateLimiter? second = state.rateLimiterFor(
        owner: Object(),
        rateLimit: const RateLimit(requests: 3, perSeconds: 2),
        clock: fakeClock,
      );

      expect(first, isNotNull);
      expect(second, same(first));
      expect(
        HttpExtensionRequestState().rateLimiterFor(
          owner: Object(),
          rateLimit: null,
          clock: fakeClock,
        ),
        isNull,
      );
    });

    test('counts every failover attempt', () async {
      siteA.statusCode = 503;
      final Interpreter interpreter = _interpreter(
        uid: _uniqueUid('attempts'),
        policy: RequestPolicy(
          rateLimit: const RateLimit(requests: 1, perSeconds: 5),
          mirrors: <String>[siteA.base, siteB.base],
        ),
      );

      await _fetch(interpreter, '${siteA.base}/page');

      expect(fakeClock.waits, <Duration>[const Duration(seconds: 5)]);
    });
  });

  group('headers', () {
    test('apply policy headers below session and per-call headers', () async {
      final Interpreter interpreter = _interpreter(
        uid: _uniqueUid('headers'),
        policy: const RequestPolicy(
          defaultHeaders: <String, String>{
            'X-Default': 'default',
            'user-agent': 'default-agent',
            'X-Session': 'default',
            'X-Call': 'default',
          },
          userAgent: 'policy-agent',
        ),
      );

      await interpreter.runFunction(
        'useSessionHeaders',
        arguments: {
          'headers': <String, String>{
            'x-session': 'session',
            'X-Call': 'session',
          },
        },
      );
      final Map<String, dynamic> result = await _fetch(
        interpreter,
        '${siteA.base}/headers',
        headers: <String, String>{'x-call': 'call'},
      );

      final Map<String, String> received = siteA.receivedHeaders.single;
      expect(received['user-agent'], 'policy-agent');
      expect(received['x-default'], 'default');
      expect(received['x-session'], 'session');
      expect(received['x-call'], 'call');
      expect(result['status'], 200);
    });

    test('session and per-call user agents override the policy one', () async {
      final Interpreter interpreter = _interpreter(
        uid: _uniqueUid('agent'),
        policy: const RequestPolicy(userAgent: 'policy-agent'),
      );

      await interpreter.runFunction(
        'useSessionHeaders',
        arguments: {
          'headers': <String, String>{'User-Agent': 'session-agent'},
        },
      );
      await _fetch(interpreter, '${siteA.base}/session');
      await _fetch(
        interpreter,
        '${siteA.base}/call',
        headers: <String, String>{'user-agent': 'call-agent'},
      );

      expect(siteA.receivedHeaders[0]['user-agent'], 'session-agent');
      expect(siteA.receivedHeaders[1]['user-agent'], 'call-agent');
    });

    test('policy headers never leak into protector headers', () async {
      final Interpreter interpreter = _interpreter(
        uid: _uniqueUid('protector'),
        policy: const RequestPolicy(
          defaultHeaders: <String, String>{'X-Default': 'default'},
          userAgent: 'policy-agent',
        ),
      );

      expect(await interpreter.runFunction('sessionHeaders'), isEmpty);
      await interpreter.runFunction(
        'useSessionHeaders',
        arguments: {
          'headers': <String, String>{'cookie': 'session=1'},
        },
      );
      await _fetch(interpreter, '${siteA.base}/');

      final HttpModule module =
          interpreter.builtinModule(HttpModule.module_name) as HttpModule;
      expect(module.getHeaders(), <String, String>{'cookie': 'session=1'});
      expect(await interpreter.runFunction('sessionHeaders'), <String, String>{
        'cookie': 'session=1',
      });
    });
  });

  group('mirrors', () {
    test('fail over to the next mirror on a 5xx response', () async {
      siteA.statusCode = 503;
      final Interpreter interpreter = _interpreter(
        uid: _uniqueUid('failover'),
        policy: RequestPolicy(mirrors: <String>[siteA.base, siteB.base]),
      );

      final Map<String, dynamic> result = await _fetch(
        interpreter,
        '${siteA.base}/title/1?page=2',
      );

      expect(result['status'], 200);
      expect(result['body']['site'], 'b');
      expect(siteA.receivedPaths, <String>['/title/1?page=2']);
      expect(siteB.receivedPaths, <String>['/title/1?page=2']);
    });

    test('fail over to the next mirror on a 403 response', () async {
      siteA.statusCode = 403;
      final Interpreter interpreter = _interpreter(
        uid: _uniqueUid('forbidden'),
        policy: RequestPolicy(mirrors: <String>[siteA.base, siteB.base]),
      );

      final Map<String, dynamic> result = await _fetch(
        interpreter,
        '${siteA.base}/title/1',
      );

      expect(result['status'], 200);
      expect(result['body']['site'], 'b');
      expect(siteA.receivedPaths, <String>['/title/1']);
    });

    test('returns the first 403 when every mirror forbids the request',
        () async {
      siteA.statusCode = 403;
      siteB.statusCode = 403;
      final Interpreter interpreter = _interpreter(
        uid: _uniqueUid('all-forbidden'),
        policy: RequestPolicy(mirrors: <String>[siteA.base, siteB.base]),
      );

      final Map<String, dynamic> result = await _fetch(
        interpreter,
        '${siteA.base}/title/1',
      );

      expect(result['status'], 403);
      expect(result['body']['site'], 'a');
    });

    test('fail over to the next mirror when a port is closed', () async {
      final String closedBase = 'http://127.0.0.1:${await _closedPort()}';
      final Interpreter interpreter = _interpreter(
        uid: _uniqueUid('closed'),
        policy: RequestPolicy(mirrors: <String>['$closedBase/', siteB.base]),
      );

      final Map<String, dynamic> result = await _fetch(
        interpreter,
        '$closedBase/list',
      );

      expect(result['body']['site'], 'b');
      expect(siteB.receivedPaths, <String>['/list']);
    });

    test('fail over httpPost and resend the body', () async {
      siteA.statusCode = 502;
      final Interpreter interpreter = _interpreter(
        uid: _uniqueUid('post'),
        policy: RequestPolicy(mirrors: <String>[siteA.base, siteB.base]),
      );

      final Map<dynamic, dynamic> result =
          await interpreter.runFunction(
                'send',
                arguments: <String, dynamic>{
                  'url': '${siteA.base}/search',
                  'body': 'query=one',
                },
              )
              as Map;

      expect(result['status'], 200);
      expect(siteA.receivedBodies, <String>['query=one']);
      expect(siteB.receivedBodies, <String>['query=one']);
    });

    test('surface the last response when every mirror fails', () async {
      siteA.statusCode = 503;
      siteB.statusCode = 500;
      final Interpreter interpreter = _interpreter(
        uid: _uniqueUid('all-fail'),
        policy: RequestPolicy(mirrors: <String>[siteA.base, siteB.base]),
      );

      final Map<String, dynamic> result = await _fetch(
        interpreter,
        '${siteA.base}/x',
      );

      expect(result['status'], 500);
      expect(result['body']['site'], 'b');
      expect(siteA.hits, 1);
      expect(siteB.hits, 1);
    });

    test(
      'surface the last error when every mirror drops the connection',
      () async {
        final ServerSocket firstDropping = await _droppingServer();
        final ServerSocket secondDropping = await _droppingServer();
        addTearDown(firstDropping.close);
        addTearDown(secondDropping.close);
        final String firstBase = 'http://127.0.0.1:${firstDropping.port}';
        final String secondBase = 'http://127.0.0.1:${secondDropping.port}';
        final Interpreter interpreter = _interpreter(
          uid: _uniqueUid('unreachable'),
          policy: RequestPolicy(mirrors: <String>[firstBase, secondBase]),
        );

        await expectLater(
          _fetch(interpreter, '$firstBase/x'),
          throwsA(predicate((Object error) => '$error'.contains(secondBase))),
        );
      },
    );

    test('do not fail over a 4xx response', () async {
      siteA.statusCode = 404;
      final Interpreter interpreter = _interpreter(
        uid: _uniqueUid('client-error'),
        policy: RequestPolicy(mirrors: <String>[siteA.base, siteB.base]),
      );

      final Map<String, dynamic> result = await _fetch(
        interpreter,
        '${siteA.base}/missing',
      );

      expect(result['status'], 404);
      expect(siteB.hits, 0);
    });

    test('leave urls outside the declared mirrors untouched', () async {
      siteC.statusCode = 503;
      final Interpreter interpreter = _interpreter(
        uid: _uniqueUid('foreign'),
        policy: RequestPolicy(mirrors: <String>[siteA.base, siteB.base]),
      );

      final Map<String, dynamic> result = await _fetch(
        interpreter,
        '${siteC.base}/cdn',
      );

      expect(result['status'], 503);
      expect(siteC.hits, 1);
      expect(siteA.hits + siteB.hits, 0);
    });

    test('try the user-selected mirror first', () async {
      final Interpreter interpreter = _interpreter(
        uid: _uniqueUid('selected'),
        policy: RequestPolicy(mirrors: <String>[siteA.base, siteB.base]),
        preferences: <String, Object?>{'__mirror': '${siteB.base}/'},
      );

      final Map<String, dynamic> result = await _fetch(
        interpreter,
        '${siteA.base}/feed',
      );

      expect(result['body']['site'], 'b');
      expect(siteA.hits, 0);
      expect(await interpreter.runFunction('mirror'), siteB.base);
    });

    test('ignore a selected mirror that is not declared', () async {
      final Interpreter interpreter = _interpreter(
        uid: _uniqueUid('undeclared'),
        policy: RequestPolicy(mirrors: <String>[siteA.base, siteB.base]),
        preferences: <String, Object?>{'__mirror': siteC.base},
      );

      final Map<String, dynamic> result = await _fetch(
        interpreter,
        '${siteB.base}/feed',
      );

      expect(result['body']['site'], 'a');
      expect(siteC.hits, 0);
      expect(await interpreter.runFunction('mirror'), siteA.base);
    });

    test('remember the last working mirror across interpreters', () async {
      final String uid = _uniqueUid('sticky');
      final RequestPolicy policy = RequestPolicy(
        mirrors: <String>[siteA.base, siteB.base],
      );
      siteA.statusCode = 503;
      final Interpreter first = _interpreter(uid: uid, policy: policy);
      await _fetch(first, '${siteA.base}/one');
      siteA.statusCode = 200;

      final Interpreter second = _interpreter(uid: uid, policy: policy);
      final Map<String, dynamic> result = await _fetch(
        second,
        '${siteA.base}/two',
      );

      expect(result['body']['site'], 'b');
      expect(siteA.hits, 1);
      expect(await second.runFunction('mirror'), siteB.base);

      final Interpreter otherExtension = _interpreter(
        uid: _uniqueUid('sticky'),
        policy: policy,
      );
      expect(await otherExtension.runFunction('mirror'), siteA.base);
    });

    test('prefer the selected mirror over the last working one', () async {
      final String uid = _uniqueUid('selected-over-sticky');
      final RequestPolicy policy = RequestPolicy(
        mirrors: <String>[siteA.base, siteB.base],
      );
      siteA.statusCode = 503;
      await _fetch(_interpreter(uid: uid, policy: policy), '${siteA.base}/');
      siteA.statusCode = 200;
      fakeClock.current += HttpRequestStateRegistry.mirrorFailureCooldown;

      final Interpreter selecting = _interpreter(
        uid: uid,
        policy: policy,
        preferences: <String, Object?>{'__mirror': siteA.base},
      );
      final Map<String, dynamic> result = await _fetch(
        selecting,
        '${siteB.base}/',
      );

      expect(result['body']['site'], 'a');
    });

    test('demote a failing selected mirror until its cooldown ends', () async {
      final String uid = _uniqueUid('cooldown');
      final RequestPolicy policy = RequestPolicy(
        mirrors: <String>[siteA.base, siteB.base],
      );
      final Interpreter selecting = _interpreter(
        uid: uid,
        policy: policy,
        preferences: <String, Object?>{'__mirror': siteA.base},
      );
      siteA.statusCode = 503;

      expect((await _fetch(selecting, '${siteA.base}/1'))['body']['site'], 'b');
      siteA.statusCode = 200;
      expect((await _fetch(selecting, '${siteA.base}/2'))['body']['site'], 'b');
      expect(await selecting.runFunction('mirror'), siteB.base);
      expect(siteA.hits, 1);

      final Interpreter sibling = _interpreter(
        uid: uid,
        policy: policy,
        preferences: <String, Object?>{'__mirror': siteA.base},
      );
      expect((await _fetch(sibling, '${siteA.base}/3'))['body']['site'], 'b');
      expect(siteA.hits, 1);

      fakeClock.current += HttpRequestStateRegistry.mirrorFailureCooldown;
      expect((await _fetch(selecting, '${siteA.base}/4'))['body']['site'], 'a');
      expect(siteA.hits, 2);
    });

    test('give up on a silent mirror after the failover timeout', () async {
      final _SilentServer silent = await _SilentServer.start();
      addTearDown(silent.close);
      HttpRequestStateRegistry.failoverAttemptTimeout = const Duration(
        milliseconds: 300,
      );
      final Interpreter interpreter = _interpreter(
        uid: _uniqueUid('silent'),
        policy: RequestPolicy(mirrors: <String>[silent.base, siteB.base]),
        preferences: <String, Object?>{'__mirror': silent.base},
      );
      final Stopwatch stopwatch = Stopwatch()..start();

      final Map<String, dynamic> first = await _fetch(
        interpreter,
        '${silent.base}/one',
      );
      final Map<String, dynamic> second = await _fetch(
        interpreter,
        '${silent.base}/two',
      );

      expect(first['body']['site'], 'b');
      expect(second['body']['site'], 'b');
      expect(silent.heldConnections, hasLength(1));
      expect(stopwatch.elapsed, lessThan(const Duration(seconds: 10)));
    });

    test('shorten only attempts that have a fallback', () async {
      final HttpRequestPolicyEnforcer enforcer = HttpRequestPolicyEnforcer(
        host: const ExtensionHost(
          requestPolicy: RequestPolicy(
            mirrors: <String>[
              'https://a.example',
              'https://b.example',
              'https://c.example',
            ],
          ),
        ),
        state: HttpExtensionRequestState(),
      );
      final List<Duration> timeouts = <Duration>[];

      await expectLater(
        enforcer.send('https://a.example/x', (Uri uri, Duration timeout) {
          timeouts.add(timeout);
          throw const SocketException('unreachable');
        }),
        throwsA(isA<SocketException>()),
      );
      await enforcer.send('https://elsewhere.example/x', (
        Uri uri,
        Duration timeout,
      ) async {
        timeouts.add(timeout);
        return http.Response('', 200);
      });

      expect(timeouts, <Duration>[
        HttpRequestStateRegistry.defaultFailoverAttemptTimeout,
        HttpRequestStateRegistry.defaultFailoverAttemptTimeout,
        HttpUtils.requestTimeout,
        HttpUtils.requestTimeout,
      ]);
    });

    test('do not remember a mirror that answered with a 4xx', () async {
      final String uid = _uniqueUid('blocked');
      final RequestPolicy policy = RequestPolicy(
        mirrors: <String>[siteA.base, siteB.base],
      );
      siteA.statusCode = 503;
      siteB.statusCode = 403;
      final Map<String, dynamic> blocked = await _fetch(
        _interpreter(uid: uid, policy: policy),
        '${siteA.base}/guarded',
      );
      expect(blocked['status'], 403);

      siteA.statusCode = 200;
      fakeClock.current += HttpRequestStateRegistry.mirrorFailureCooldown;
      final Interpreter next = _interpreter(uid: uid, policy: policy);

      expect(await next.runFunction('mirror'), siteA.base);
      expect((await _fetch(next, '${siteB.base}/page'))['body']['site'], 'a');
    });

    test(
      'route throughWeb requests to the first candidate without failover',
      () async {
        final Interpreter interpreter = _interpreter(
          uid: _uniqueUid('web'),
          policy: RequestPolicy(
            mirrors: <String>[siteA.base, siteB.base],
            userAgent: 'policy-agent',
          ),
          preferences: <String, Object?>{'__mirror': siteB.base},
        );
        final _RecordingController controller = _RecordingController();
        await interpreter.runFunction(
          'setController',
          arguments: <String, dynamic>{'controller': controller},
        );

        final Map<dynamic, dynamic> result =
            await interpreter.runFunction(
                  'fetchThroughWeb',
                  arguments: <String, dynamic>{'url': '${siteA.base}/page'},
                )
                as Map;

        expect(result['status'], 503);
        expect(controller.loadedUrls, <String>['${siteB.base}/page']);
        expect(controller.loadedHeaders.single['User-Agent'], 'policy-agent');
      },
    );

    test('match mirror bases only on a path boundary', () {
      final HttpRequestPolicyEnforcer enforcer = HttpRequestPolicyEnforcer(
        host: const ExtensionHost(
          requestPolicy: RequestPolicy(
            mirrors: <String>[
              'https://example.org/',
              'https://example.org/api',
            ],
          ),
        ),
        state: HttpExtensionRequestState(),
      );

      expect(enforcer.matchingMirror('https://example.org.evil/x'), isNull);
      expect(
        enforcer.matchingMirror('https://example.org'),
        'https://example.org',
      );
      expect(
        enforcer.matchingMirror('https://example.org?q=1'),
        'https://example.org',
      );
      expect(
        enforcer.matchingMirror('https://example.org/apix'),
        'https://example.org',
      );
      expect(
        enforcer.matchingMirror('https://example.org/api/v1'),
        'https://example.org/api',
      );
    });
  });

  group('currentMirror', () {
    test('returns the first declared mirror without a selection', () async {
      final Interpreter interpreter = _interpreter(
        uid: _uniqueUid('current'),
        policy: RequestPolicy(mirrors: <String>['${siteA.base}//', siteB.base]),
      );

      expect(await interpreter.runFunction('mirror'), siteA.base);
    });

    test('returns null when the extension declares no mirrors', () async {
      final Interpreter withPolicy = _interpreter(
        uid: _uniqueUid('no-mirrors'),
        policy: const RequestPolicy(userAgent: 'agent'),
      );
      final Interpreter withoutPolicy = _interpreter();

      expect(await withPolicy.runFunction('mirror'), isNull);
      expect(await withoutPolicy.runFunction('mirror'), isNull);
    });
  });

  group('without a request policy', () {
    test('requests go out unchanged', () async {
      final Interpreter interpreter = Interpreter(data: _script);
      siteA.statusCode = 503;

      await interpreter.runFunction(
        'useSessionHeaders',
        arguments: {
          'headers': <String, String>{'X-Session': 'session'},
        },
      );
      final Map<String, dynamic> first = await _fetch(
        interpreter,
        '${siteA.base}/a',
        headers: <String, String>{'X-Call': 'call'},
      );
      await _fetch(interpreter, '${siteA.base}/b');

      expect(first['status'], 503);
      expect(siteA.hits, 2);
      expect(siteA.receivedPaths, <String>['/a', '/b']);
      expect(siteA.receivedHeaders.first['user-agent'], startsWith('Dart/'));
      expect(siteA.receivedHeaders.first['x-session'], 'session');
      expect(siteA.receivedHeaders.first['x-call'], 'call');
      expect(siteA.receivedHeaders.first.containsKey('x-default'), isFalse);
      expect(fakeClock.waits, isEmpty);
    });

    test('composeHeaders keeps the plain merge', () {
      final HttpRequestPolicyEnforcer enforcer = HttpRequestPolicyEnforcer(
        host: ExtensionHost.none,
        state: HttpExtensionRequestState(),
      );

      expect(
        enforcer.composeHeaders(
          sessionHeaders: <String, String>{'A': '1', 'B': '1'},
          callHeaders: <String, String>{'B': '2', 'b': '3'},
        ),
        <String, String>{'A': '1', 'B': '2', 'b': '3'},
      );
    });
  });
}
