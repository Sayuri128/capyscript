import 'dart:async';
import 'dart:io';

import 'package:capyscript/api_clients/host/extension_host.dart';
import 'package:capyscript/modules/http/policy/http_request_state.dart';
import 'package:capyscript/modules/waka_models/models/config_info/preferences/extension_preference.dart';
import 'package:capyscript/modules/waka_models/models/config_info/request_policy/request_policy.dart';
import 'package:http/http.dart' as http;

typedef HttpAttempt = Future<http.Response> Function(Uri uri);

class HttpRequestPolicyEnforcer {
  static const String userAgentHeader = 'User-Agent';

  final ExtensionHost host;
  final HttpExtensionRequestState state;

  HttpRequestPolicyEnforcer({required this.host, required this.state});

  RequestPolicy? get policy => host.requestPolicy;

  List<String> get declaredMirrors {
    final List<String> mirrors = <String>[];
    for (final String rawMirror in policy?.mirrors ?? const <String>[]) {
      final String mirror = normalizeMirror(rawMirror);
      if (mirror.isNotEmpty && !mirrors.contains(mirror)) {
        mirrors.add(mirror);
      }
    }
    return mirrors;
  }

  static String normalizeMirror(String mirror) {
    String normalized = mirror.trim();
    while (normalized.endsWith('/')) {
      normalized = normalized.substring(0, normalized.length - 1);
    }
    return normalized;
  }

  Map<String, String> composeHeaders({
    required Map<String, String> sessionHeaders,
    required Map<String, String> callHeaders,
  }) {
    final Map<String, String> scriptHeaders = <String, String>{
      ...sessionHeaders,
      ...callHeaders,
    };
    final Map<String, String> policyHeaders = _policyHeaders();
    if (policyHeaders.isEmpty) {
      return scriptHeaders;
    }
    return _overrideIgnoringCase(policyHeaders, scriptHeaders);
  }

  Map<String, String> _policyHeaders() {
    final RequestPolicy? currentPolicy = policy;
    if (currentPolicy == null) {
      return <String, String>{};
    }
    final String? userAgent = currentPolicy.userAgent;
    return _overrideIgnoringCase(currentPolicy.defaultHeaders, <String, String>{
      if (userAgent != null && userAgent.isNotEmpty) userAgentHeader: userAgent,
    });
  }

  static Map<String, String> _overrideIgnoringCase(
    Map<String, String> base,
    Map<String, String> overrides,
  ) {
    final Map<String, String> merged = Map<String, String>.of(base);
    for (final String overrideKey in overrides.keys) {
      final String lowerKey = overrideKey.toLowerCase();
      merged.removeWhere(
        (String existingKey, String _) => existingKey.toLowerCase() == lowerKey,
      );
    }
    merged.addAll(overrides);
    return merged;
  }

  Future<void> acquireSlot() async {
    await state
        .rateLimiterFor(policy?.rateLimit, HttpRequestStateRegistry.clock)
        ?.acquire();
  }

  Future<List<String>> orderedMirrors() async {
    final List<String> declared = declaredMirrors;
    if (declared.isEmpty) {
      return <String>[];
    }
    final List<String> ordered = <String>[];
    final String? selected = await _selectedMirror(declared);
    if (selected != null) {
      ordered.add(selected);
    }
    final String? lastWorking = state.lastWorkingMirror;
    if (lastWorking != null &&
        declared.contains(lastWorking) &&
        !ordered.contains(lastWorking)) {
      ordered.add(lastWorking);
    }
    for (final String mirror in declared) {
      if (!ordered.contains(mirror)) {
        ordered.add(mirror);
      }
    }
    return ordered;
  }

  Future<String?> currentMirror() async {
    final List<String> ordered = await orderedMirrors();
    if (ordered.isEmpty) {
      return null;
    }
    return ordered.first;
  }

  Future<String?> _selectedMirror(List<String> declared) async {
    Object? preferenceValue;
    try {
      preferenceValue = await host.resolvePreference(
        ExtensionPreference.mirrorKey,
      );
    } catch (_) {
      return null;
    }
    if (preferenceValue is! String) {
      return null;
    }
    final String selected = normalizeMirror(preferenceValue);
    if (declared.contains(selected)) {
      return selected;
    }
    return null;
  }

  String? matchingMirror(String url) {
    String? bestMatch;
    for (final String mirror in declaredMirrors) {
      if (_isUnderBase(url, mirror) &&
          (bestMatch == null || mirror.length > bestMatch.length)) {
        bestMatch = mirror;
      }
    }
    return bestMatch;
  }

  static bool _isUnderBase(String url, String base) {
    if (!url.startsWith(base)) {
      return false;
    }
    if (url.length == base.length) {
      return true;
    }
    final String nextCharacter = url[base.length];
    return nextCharacter == '/' || nextCharacter == '?' || nextCharacter == '#';
  }

  Future<String> resolveWebUrl(String url) async {
    final String? matchedMirror = matchingMirror(url);
    if (matchedMirror == null) {
      return url;
    }
    final List<String> ordered = await orderedMirrors();
    return '${ordered.first}${url.substring(matchedMirror.length)}';
  }

  Future<http.Response> send(String url, HttpAttempt attempt) async {
    final String? matchedMirror = matchingMirror(url);
    if (matchedMirror == null) {
      await acquireSlot();
      return await attempt(Uri.parse(url));
    }
    final String pathAfterMirror = url.substring(matchedMirror.length);
    final List<String> candidates = await orderedMirrors();
    for (int index = 0; index < candidates.length; index++) {
      final String mirror = candidates[index];
      final bool hasNextCandidate = index < candidates.length - 1;
      await acquireSlot();
      try {
        final http.Response response = await attempt(
          Uri.parse('$mirror$pathAfterMirror'),
        );
        if (isServerError(response.statusCode)) {
          if (hasNextCandidate) {
            continue;
          }
          return response;
        }
        state.lastWorkingMirror = mirror;
        return response;
      } catch (error) {
        if (!hasNextCandidate || !isConnectionError(error)) {
          rethrow;
        }
      }
    }
    throw StateError('no mirror candidates for $url');
  }

  static bool isServerError(int statusCode) {
    return statusCode >= 500 && statusCode < 600;
  }

  static bool isConnectionError(Object error) {
    return error is SocketException ||
        error is TlsException ||
        error is HttpException ||
        error is http.ClientException ||
        error is TimeoutException;
  }
}
