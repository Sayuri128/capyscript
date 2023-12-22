/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/modules/abstract/external_object.dart';

class HttpInterceptorControllerResponse extends ExternalObject {
  final String body;
  final Map<String, String> headers;
  final int statusCode;
  final Map<String, String> cookies;
  final Map<String, dynamic> data;

  const HttpInterceptorControllerResponse(
      {required this.body,
      required this.data,
      required this.statusCode,
      required this.headers,
      required this.cookies});

  @override
  callFunction(String name, {List? ordinalArguments}) {}

  operator [](String key) {
    if (key == "body") return body;
    if (key == "data") return data;
    if (key == "statusCode") return statusCode;
    if (key == "headers") return headers;
    if (key == "cookies") return cookies;
    return null;
  }

  @override
  getField(String name) {
    return this[name];
  }

  @override
  void setField(String name, value) {}
}

abstract class HttpInterceptorController {
  Future<HttpInterceptorControllerResponse> loadPage(
      {required String url,
      String? method,
      Map<String, String>? headers,
      String? body});

  Future<dynamic> executeJsScript(String code);
}
