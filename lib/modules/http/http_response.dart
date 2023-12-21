/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

class CapyHttpResponse {
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

}
