/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

class HttpUtils {
  static const Duration requestTimeout = Duration(seconds: 60);

  static String _encode(dynamic value) => Uri.encodeComponent(value.toString());

  static Future<String> buildUri(String input,
      {required Map<String, dynamic> params,
      required Map<String, dynamic> paths}) async {
    String url = "$input?";

    for (var element in paths.entries) {
      url = url.replaceFirst(element.key, element.value);
    }

    for (var element in params.entries) {
      if (element.value is Iterable) {
        final List<dynamic> values = (element.value as Iterable).toList();
        if (values.isEmpty) {
          continue;
        }
        url = '$url${url.endsWith('?') ? '' : '&'}'
            '${values.map((e) => '${element.key}[]=${_encode(e)}').join('&')}';
      } else if (element.value is Map) {
        url = '$url${url.endsWith('?') ? '' : '&'}'
            '${(element.value as Map).entries.map((e) => '${element.key}[${e.key}]=${_encode(e.value)}').join('&')}';
      } else {
        url =
            '$url${url.endsWith('?') ? '' : '&'}${element.key}=${_encode(element.value)}';
      }
    }

    return url;
  }
}
