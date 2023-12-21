/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/modules/abstract/external_object.dart';

class CapyHttpResponse extends ExternalObject {
  final int statusCode;
  final String body;

  const CapyHttpResponse({
    required this.statusCode,
    required this.body,
  });

  @override
  String toString() {
    return 'CapyHttpResponse{statusCode: $statusCode, body: $body}';
  }

  operator [](String key) {
    if (key == "statusCode") return statusCode;
    if (key == "body") return body;
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

}
