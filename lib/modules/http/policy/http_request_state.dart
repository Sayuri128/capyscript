import 'package:capyscript/modules/http/policy/http_clock.dart';
import 'package:capyscript/modules/http/policy/http_rate_limiter.dart';
import 'package:capyscript/modules/waka_models/models/config_info/request_policy/request_policy.dart';

class HttpExtensionRequestState {
  HttpRateLimiter? _rateLimiter;
  String? lastWorkingMirror;

  HttpRateLimiter? rateLimiterFor(RateLimit? rateLimit, HttpClock clock) {
    if (rateLimit == null ||
        rateLimit.requests <= 0 ||
        rateLimit.window <= Duration.zero) {
      return null;
    }
    final HttpRateLimiter? existing = _rateLimiter;
    if (existing != null &&
        existing.matches(rateLimit.requests, rateLimit.window)) {
      return existing;
    }
    return _rateLimiter = HttpRateLimiter(
      maxRequests: rateLimit.requests,
      window: rateLimit.window,
      clock: clock,
    );
  }
}

class HttpRequestStateRegistry {
  static final Map<String, HttpExtensionRequestState> _statesByExtensionUid =
      <String, HttpExtensionRequestState>{};

  static HttpClock clock = const SystemHttpClock();

  static HttpExtensionRequestState stateFor(String? extensionUid) {
    if (extensionUid == null) {
      return HttpExtensionRequestState();
    }
    return _statesByExtensionUid.putIfAbsent(
      extensionUid,
      HttpExtensionRequestState.new,
    );
  }

  static void reset() {
    _statesByExtensionUid.clear();
    clock = const SystemHttpClock();
  }
}
