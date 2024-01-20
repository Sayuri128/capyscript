/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/modules/http/http_response.dart';

class CapyHttpBrowserResponse extends CapyHttpResponse {
  final Map<String, String> cookies;

  const CapyHttpBrowserResponse({
    required this.cookies,
    required super.statusCode,
    required super.body,
    required super.contentLength,
    required super.headers,
  });

  @override
  operator [](String key) {
    if (key == "cookies") return cookies;
    return super[key];
  }

  @override
  getField(String name) {
    return this[name];
  }
}
