import 'dart:io';

import 'package:capyscript/Interpreter/interpreter.dart';
import 'package:test/test.dart';

void main() {
  late HttpServer server;

  setUp(() async {
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    server.listen((HttpRequest request) async {
      request.response.headers.contentType = ContentType.binary;
      request.response.add(<int>[0, 0, 0, 7, 0, 0, 1, 0]);
      await request.response.close();
    });
  });

  tearDown(() => server.close(force: true));

  test('responses expose the raw body bytes', () async {
    final String base = 'http://127.0.0.1:${server.port}';
    final dynamic result = await Interpreter(data: '''
      import "http";
      import "bytes";
      function main() {
        response = httpGet({"url": "$base/ids.nozomi"});
        return bytesToInts(response["bodyBytes"]);
      }
    ''').interpret();

    expect(result, equals(<int>[7, 256]));
  });
}
