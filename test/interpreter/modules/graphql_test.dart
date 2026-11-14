import 'dart:convert';
import 'dart:io';

import 'package:capyscript/Interpreter/interpreter.dart';
import 'package:capyscript/api_clients/source_error.dart';
import 'package:capyscript/modules/graphql/graphql_client.dart';
import 'package:test/test.dart';

class _GraphQLServer {
  final HttpServer server;
  final List<Map<String, dynamic>> payloads = <Map<String, dynamic>>[];
  final List<HttpHeaders> headers = <HttpHeaders>[];
  final List<String> methods = <String>[];
  final Set<String> knownHashes = <String>{};
  int statusCode = 200;

  _GraphQLServer(this.server) {
    server.listen(_handle);
  }

  String get url => 'http://127.0.0.1:${server.port}/graphql';

  Future<void> _handle(HttpRequest request) async {
    methods.add(request.method);
    headers.add(request.headers);
    final Map<String, dynamic> payload;
    if (request.method == 'GET') {
      final Map<String, String> query = request.uri.queryParameters;
      payload = {
        if (query['query'] != null) 'query': query['query'],
        if (query['variables'] != null)
          'variables': jsonDecode(query['variables']!),
        if (query['extensions'] != null)
          'extensions': jsonDecode(query['extensions']!),
      };
    } else {
      payload = jsonDecode(await utf8.decoder.bind(request).join())
          as Map<String, dynamic>;
    }
    payloads.add(payload);
    request.response.statusCode = statusCode;
    request.response.headers.contentType = ContentType.json;
    request.response.write(jsonEncode(_answer(payload)));
    await request.response.close();
  }

  Map<String, dynamic> _answer(Map<String, dynamic> payload) {
    final dynamic extensions = payload['extensions'];
    final String? query = payload['query'] as String?;
    if (extensions is Map && extensions['persistedQuery'] is Map) {
      final String hash = extensions['persistedQuery']['sha256Hash'] as String;
      if (query != null) {
        knownHashes.add(hash);
      } else if (!knownHashes.contains(hash)) {
        return {
          'errors': [
            {
              'message': 'PersistedQueryNotFound',
              'extensions': {'code': 'PERSISTED_QUERY_NOT_FOUND'}
            }
          ]
        };
      }
      return {
        'data': {'persisted': hash}
      };
    }
    if (query != null && query.contains('broken')) {
      return {
        'errors': [
          {'message': 'Cannot query field "broken"'},
          {'message': 'second problem'}
        ]
      };
    }
    return {
      'data': {
        'echo': payload['variables'],
        'operation': payload['operationName']
      }
    };
  }
}

void main() {
  late _GraphQLServer graphql;

  setUp(() async {
    graphql = _GraphQLServer(
        await HttpServer.bind(InternetAddress.loopbackIPv4, 0));
  });

  tearDown(() => graphql.server.close(force: true));

  Interpreter interpreterFor(String body) => Interpreter(data: '''
    import "graphql";
    import "dependencies";
    function graphqlUrl() { return "${graphql.url}"; }
    $body
  ''');

  test('query posts JSON with variables, operation name and headers',
      () async {
    final dynamic result = await interpreterFor(r'''
      function main() {
        client = createGraphQLClient({"url": graphqlUrl(), "headers": {"X-Site": "demo"}});
        client.setHeader("Authorization", "Bearer guest");
        return client.query("query Search($q: String) { search(q: $q) { id } }", {"q": "naruto"}, "Search");
      }
    ''').interpret();

    expect(result, {
      'echo': {'q': 'naruto'},
      'operation': 'Search'
    });
    expect(graphql.methods, ['POST']);
    expect(graphql.headers.single.value('x-site'), 'demo');
    expect(graphql.headers.single.value('authorization'), 'Bearer guest');
    expect(graphql.headers.single.contentType?.mimeType, 'application/json');
  });

  test('GET clients send the query in the url', () async {
    final dynamic result = await interpreterFor(r'''
      function main() {
        client = createGraphQLClient({"url": graphqlUrl(), "method": "get"});
        return client.query("{ list }", {"page": 2});
      }
    ''').interpret();

    expect(result['echo'], {'page': 2});
    expect(graphql.methods, ['GET']);
    expect(graphql.payloads.single['query'], '{ list }');
  });

  test('query throws the GraphQL error messages, request returns them',
      () async {
    final Interpreter interpreter = interpreterFor(r'''
      function strict() {
        return createGraphQLClient(graphqlUrl()).query("{ broken }");
      }
      function lenient() {
        response = createGraphQLClient(graphqlUrl()).request("{ broken }");
        return [response["statusCode"], response["errors"].length, response["data"]];
      }
    ''');

    await expectLater(
        interpreter.runFunction('strict'),
        throwsA(predicate((error) => error.toString().contains(
            'GraphQL error: Cannot query field "broken"; second problem'))));
    expect(await interpreter.runFunction('lenient'), [200, 2, null]);
  });

  test('persisted sends only the hash and retries with the query once',
      () async {
    final Interpreter interpreter = interpreterFor(r'''
      function main() {
        client = createGraphQLClient(graphqlUrl());
        return client.persisted(null, {"id": 1}, null, "query Show { show { id } }");
      }
    ''');
    final String hash = GraphQLClient.hashQuery('query Show { show { id } }');

    expect(await interpreter.interpret(), {'persisted': hash});
    expect(graphql.payloads.map((payload) => payload.containsKey('query')),
        [false, true]);

    graphql.payloads.clear();
    expect(await interpreter.interpret(), {'persisted': hash});
    expect(graphql.payloads.length, 1);
  });

  test('HTTP 429 becomes a rateLimited source error', () async {
    graphql.statusCode = 429;

    await expectLater(
        interpreterFor(r'''
          function main() { return createGraphQLClient(graphqlUrl()).query("{ list }"); }
        ''').runFunction('main'),
        throwsA(isA<SourceError>()
            .having((error) => error.kind, 'kind', SourceErrorKind.rateLimited)));
  });

  test('a client provided in onInit is shared by every function', () async {
    final Interpreter interpreter = interpreterFor(r'''
      function onInit() {
        provide("api", createGraphQLClient(graphqlUrl()));
      }
      function passProtector(body, headers, cookies) {
        api = inject("api");
        api.setHeader("Cookie", cookies["session"]);
      }
      function getGallery(page) {
        return inject("api").query("{ list }", {"page": page})["echo"];
      }
    ''');

    await interpreter.runFunction('passProtector', arguments: {
      'body': '',
      'headers': <String, String>{},
      'cookies': {'session': 'abc'}
    });
    expect(await interpreter.runFunction('getGallery', arguments: {'page': 3}),
        {'page': 3});
    expect(graphql.headers.single.value('cookie'), 'abc');
  });

  test('createGraphQLClient rejects relative urls and unknown methods',
      () async {
    await expectLater(
        interpreterFor(r'''
          function main() { return createGraphQLClient("/graphql"); }
        ''').interpret(),
        throwsA(predicate((error) => error.toString().contains('must be absolute'))));
    await expectLater(
        interpreterFor(r'''
          function main() { return createGraphQLClient({"url": graphqlUrl(), "method": "PUT"}); }
        ''').interpret(),
        throwsA(predicate((error) => error.toString().contains('POST or GET'))));
  });
}
