import 'dart:convert';

import 'package:capyscript/api_clients/source_error.dart';
import 'package:capyscript/modules/abstract/external_object.dart';
import 'package:capyscript/modules/http/http_module.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

class GraphQLClient extends ExternalObject {
  final String url;
  final bool useGet;
  final Map<String, String> _headers;
  final HttpModule Function() _http;

  GraphQLClient({
    required this.url,
    required Map<String, String> headers,
    required this.useGet,
    required HttpModule Function() http,
  })  : _headers = Map.of(headers),
        _http = http;

  Map<String, String> get headers => Map.unmodifiable(_headers);

  @override
  dynamic getField(String name) {
    switch (name) {
      case "url":
        return url;
      case "headers":
        return Map.of(_headers);
      case "method":
        return useGet ? "GET" : "POST";
    }
    return null;
  }

  @override
  void setField(String name, dynamic value) {
    throw Exception("GraphQL client field $name is read-only; use setHeader");
  }

  @override
  dynamic callFunction(String name, {List<dynamic>? ordinalArguments}) {
    final List<dynamic> arguments = ordinalArguments ?? const [];
    dynamic argument(int index) =>
        index < arguments.length ? arguments[index] : null;
    switch (name) {
      case "query":
        return _query(argument(0), argument(1), argument(2));
      case "request":
        return _request(_requireQuery(argument(0)), _variables(argument(1)),
            _optionalString(argument(2)));
      case "persisted":
        return _persisted(argument(0), argument(1), argument(2), argument(3));
      case "setHeader":
        _setHeader(argument(0), argument(1));
        return null;
    }
    throw Exception(
        "GraphQL client has no method $name (query, request, persisted, setHeader)");
  }

  static String hashQuery(String query) =>
      sha256.convert(utf8.encode(query)).toString();

  Future<dynamic> _query(
      dynamic query, dynamic variables, dynamic operationName) async {
    final Map<String, dynamic> result = await _request(_requireQuery(query),
        _variables(variables), _optionalString(operationName));
    return _dataOrThrow(result);
  }

  Future<dynamic> _persisted(dynamic hash, dynamic variables,
      dynamic operationName, dynamic query) async {
    final String? queryText = query == null ? null : _requireQuery(query);
    String? sha = _optionalString(hash);
    if (sha == null || sha.isEmpty) {
      if (queryText == null) {
        throw Exception("persisted needs a sha256 hash or the query text");
      }
      sha = hashQuery(queryText);
    }
    final Map<String, dynamic> extensions = {
      "persistedQuery": {"version": 1, "sha256Hash": sha},
    };
    Map<String, dynamic> result = await _request(
        null, _variables(variables), _optionalString(operationName),
        extensions: extensions);
    if (queryText != null && _persistedQueryNotFound(result)) {
      result = await _request(
          queryText, _variables(variables), _optionalString(operationName),
          extensions: extensions);
    }
    return _dataOrThrow(result);
  }

  Future<Map<String, dynamic>> _request(
      String? query, Map<String, dynamic>? variables, String? operationName,
      {Map<String, dynamic>? extensions}) async {
    final Map<String, dynamic> payload = {
      if (query != null) "query": query,
      if (variables != null) "variables": variables,
      if (operationName != null) "operationName": operationName,
      if (extensions != null) "extensions": extensions,
    };
    final Map<String, String> requestHeaders = {
      "Accept": "application/graphql-response+json, application/json",
      ..._headers,
    };
    final http.Response response;
    if (useGet) {
      response =
          await _http().send("GET", _getUrl(payload), headers: requestHeaders);
    } else {
      response = await _http().send("POST", url,
          headers: {"Content-Type": "application/json", ...requestHeaders},
          body: jsonEncode(payload));
    }
    return _decode(response);
  }

  String _getUrl(Map<String, dynamic> payload) {
    final Uri base = Uri.parse(url);
    final Map<String, String> query = {
      ...base.queryParameters,
      for (final MapEntry<String, dynamic> entry in payload.entries)
        entry.key:
            entry.value is String ? entry.value as String : jsonEncode(entry.value),
    };
    return base.replace(queryParameters: query).toString();
  }

  Map<String, dynamic> _decode(http.Response response) {
    if (response.statusCode == 429) {
      throw SourceError(
          SourceErrorKind.rateLimited, "GraphQL $url answered HTTP 429");
    }
    final String body = utf8.decode(response.bodyBytes, allowMalformed: true);
    dynamic decoded;
    try {
      decoded = jsonDecode(body);
    } on FormatException {
      decoded = null;
    }
    if (decoded is! Map) {
      throw Exception(
          "GraphQL $url answered HTTP ${response.statusCode} without a JSON body");
    }
    return {
      "statusCode": response.statusCode,
      "data": decoded["data"],
      "errors": decoded["errors"] ?? [],
      "extensions": decoded["extensions"],
      "headers": response.headers,
    };
  }

  dynamic _dataOrThrow(Map<String, dynamic> result) {
    final dynamic errors = result["errors"];
    if (errors is List && errors.isNotEmpty) {
      throw Exception("GraphQL error: ${_messages(errors)}");
    }
    final int statusCode = result["statusCode"] as int;
    if (statusCode >= 400) {
      throw Exception("GraphQL $url answered HTTP $statusCode");
    }
    return result["data"];
  }

  static bool _persistedQueryNotFound(Map<String, dynamic> result) {
    final dynamic errors = result["errors"];
    if (errors is! List) {
      return false;
    }
    return errors.any((dynamic error) {
      if (error is! Map) {
        return false;
      }
      final dynamic extensions = error["extensions"];
      final dynamic code = extensions is Map ? extensions["code"] : null;
      return code == "PERSISTED_QUERY_NOT_FOUND" ||
          error["message"] == "PersistedQueryNotFound";
    });
  }

  static String _messages(List<dynamic> errors) {
    return errors
        .map((dynamic error) =>
            error is Map && error["message"] != null ? error["message"] : error)
        .join("; ");
  }

  void _setHeader(dynamic name, dynamic value) {
    if (name == null) {
      throw Exception("setHeader needs a header name");
    }
    final String headerName = name.toString();
    _headers.removeWhere(
        (String key, _) => key.toLowerCase() == headerName.toLowerCase());
    if (value != null) {
      _headers[headerName] = value.toString();
    }
  }

  static String _requireQuery(dynamic query) {
    if (query is! String || query.trim().isEmpty) {
      throw Exception("GraphQL query must be a non-empty string, got $query");
    }
    return query;
  }

  static Map<String, dynamic>? _variables(dynamic variables) {
    if (variables == null) {
      return null;
    }
    if (variables is! Map) {
      throw Exception("GraphQL variables must be a map, got $variables");
    }
    return variables.map((key, value) => MapEntry(key.toString(), value));
  }

  static String? _optionalString(dynamic value) => value?.toString();

  @override
  String toString() => 'GraphQLClient($url)';
}
