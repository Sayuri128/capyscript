/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/modules/abstract/external_object.dart';

class CapyHttpResponse extends ExternalObject {
  final int statusCode;
  final String body;
  final int? contentLength;
  final Map<String, String> headers;

  const CapyHttpResponse(
      {required this.statusCode,
      required this.body,
      required this.contentLength,
      required this.headers});

  operator [](String key) {
    if (key == "statusCode") return statusCode;
    if (key == "body") return body;
    if (key == "contentLength") return contentLength;
    if (key == "headers") return headers;
    return null;
  }

  @override
  callFunction(String name, {List? ordinalArguments}) {
    throw Exception("Method $name not found");
  }

  @override
  getField(String name) {
    return this[name];
  }

  @override
  void setField(String name, value) {
    throw Exception("Field $name not found");
  }

  @override
  String toString() {
    return 'CapyHttpResponse{statusCode: $statusCode, body: $body, contentLength: $contentLength, headers: $headers}';
  }
}
