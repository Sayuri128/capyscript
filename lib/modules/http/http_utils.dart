/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

class HttpUtils {
  static Future<String> buildUri(String input,
      {required Map<String, dynamic> params,
      required Map<String, dynamic> paths}) async {
    String url = "$input?";

    for (var element in paths.entries) {
      url = url.replaceFirst(element.key, element.value);
    }

    for (var element in params.entries) {
      if (element.value is Iterable) {
        url = '$url${url.endsWith('?') ? '' : '&'}'
            '${(await Future.wait((element.value as List).map((e) async => "${element.key}[]=${e}"))).join('&')}';
      } else if (element.value is Map) {
        url = '$url${url.endsWith('?') ? '' : '&'}'
            '${(await Future.wait((element.value as Map).entries.map((e) async => '${element.key}[${e.key}]=${e.value}'))).join('&')}';
      } else {
        url =
            '$url${url.endsWith('?') ? '' : '&'}${element.key}=${element.value}';
      }
    }

    return url;
  }
}
