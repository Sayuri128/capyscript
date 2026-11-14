/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'dart:convert';

import 'package:capyscript/modules/bytes/text_codecs.dart';
import 'package:http/http.dart' as http;

class HttpUtils {
  static const Duration requestTimeout = Duration(seconds: 60);

  static Future<http.Response> sendRequest(
    String method,
    Uri uri, {
    required Map<String, String> headers,
    Object? body,
    Duration firstResponseTimeout = requestTimeout,
  }) async {
    final http.Request request = http.Request(method, uri);
    request.headers.addAll(headers);
    _applyBody(request, body);
    final Stopwatch elapsed = Stopwatch()..start();
    final http.Client client = http.Client();
    try {
      final http.StreamedResponse streamedResponse =
          await client.send(request).timeout(firstResponseTimeout);
      Duration remaining = requestTimeout - elapsed.elapsed;
      if (remaining < Duration.zero) {
        remaining = Duration.zero;
      }
      return await http.Response.fromStream(streamedResponse)
          .timeout(remaining);
    } finally {
      client.close();
    }
  }

  static void _applyBody(http.Request request, Object? body) {
    if (body == null) {
      return;
    }
    if (body is String) {
      request.body = body;
    } else if (body is List) {
      request.bodyBytes = body.cast<int>();
    } else if (body is Map) {
      request.bodyFields = body.cast<String, String>();
    } else {
      throw ArgumentError('Invalid request body "$body".');
    }
  }

  static String _encode(dynamic value) => Uri.encodeComponent(value.toString());

  static Future<String> buildUri(String input,
      {required Map<String, dynamic> params,
      required Map<String, dynamic> paths}) async {
    String url = "$input?";

    for (var element in paths.entries) {
      url = url.replaceFirst(element.key, element.value);
    }

    if (url.endsWith('?') && url.substring(0, url.length - 1).contains('?')) {
      url = '${url.substring(0, url.length - 1)}&';
    }

    for (var element in params.entries) {
      if (element.value is Iterable) {
        final List<dynamic> values = (element.value as Iterable).toList();
        if (values.isEmpty) {
          continue;
        }
        url = '$url${_separator(url)}'
            '${values.map((e) => '${element.key}[]=${_encode(e)}').join('&')}';
      } else if (element.value is Map) {
        url = '$url${_separator(url)}'
            '${(element.value as Map).entries.map((e) => '${element.key}[${e.key}]=${_encode(e.value)}').join('&')}';
      } else {
        url = '$url${_separator(url)}${element.key}=${_encode(element.value)}';
      }
    }

    if (url.endsWith('?') || url.endsWith('&')) {
      url = url.substring(0, url.length - 1);
    }
    return url;
  }

  static String _separator(String url) {
    if (url.endsWith('?') || url.endsWith('&')) {
      return '';
    }
    return '&';
  }

  static String decodeBody(http.Response response) {
    final List<int> bytes = response.bodyBytes;
    final String? declared = charsetOf(response.headers['content-type']);
    if (declared != null) {
      final String? canonical = TextCodecs.canonicalName(declared);
      if (canonical != null && _singleByteCyrillic.contains(canonical)) {
        return TextCodecs.decode(bytes, canonical);
      }
      return response.body;
    }
    try {
      return utf8.decode(bytes);
    } on FormatException {
      final String? sniffed = _documentCharset(bytes);
      if (sniffed != null && _singleByteCyrillic.contains(sniffed)) {
        return TextCodecs.decode(bytes, sniffed);
      }
      return response.body;
    }
  }

  static const Set<String> _singleByteCyrillic = {
    'windows-1251',
    'koi8-r',
    'koi8-u',
  };

  static final RegExp _charsetParameter =
      RegExp(r'''charset\s*=\s*["']?([\w.:-]+)''', caseSensitive: false);

  static String? charsetOf(String? contentType) {
    if (contentType == null) {
      return null;
    }
    return _charsetParameter.firstMatch(contentType)?.group(1);
  }

  static String? _documentCharset(List<int> bytes) {
    final int end = bytes.length < 4096 ? bytes.length : 4096;
    final String head = latin1.decode(bytes.sublist(0, end));
    final String? declared = charsetOf(head);
    if (declared == null) {
      return null;
    }
    return TextCodecs.canonicalName(declared);
  }
}
