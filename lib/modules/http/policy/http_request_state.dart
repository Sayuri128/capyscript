import 'package:capyscript/modules/http/policy/http_clock.dart';
import 'package:capyscript/modules/http/policy/http_rate_limiter.dart';
import 'package:capyscript/modules/waka_models/models/config_info/request_policy/request_policy.dart';

class HttpExtensionRequestState {
  HttpRateLimiter? _rateLimiter;
  String? lastWorkingMirror;
  final Map<String, Duration> _mirrorCooldownEnds = <String, Duration>{};

  HttpRateLimiter? rateLimiterFor({
    required Object owner,
    required RateLimit? rateLimit,
    required HttpClock clock,
  }) {
    final HttpRateLimit? declaredLimit = rateLimit == null
        ? null
        : HttpRateLimit(
            maxRequests: rateLimit.requests,
            window: rateLimit.window,
          );
    HttpRateLimiter? limiter = _rateLimiter;
    if (limiter == null) {
      if (declaredLimit == null || !declaredLimit.isEnforceable) {
        return null;
      }
      limiter = HttpRateLimiter.shared(clock: clock);
      _rateLimiter = limiter;
    }
    limiter.declare(owner, declaredLimit);
    if (!limiter.isActive) {
      return null;
    }
    return limiter;
  }

  bool isMirrorCoolingDown(String mirror, Duration now) {
    final Duration? cooldownEnd = _mirrorCooldownEnds[mirror];
    if (cooldownEnd == null) {
      return false;
    }
    if (cooldownEnd <= now) {
      _mirrorCooldownEnds.remove(mirror);
      return false;
    }
    return true;
  }

  void markMirrorFailed(String mirror, Duration now, Duration cooldown) {
    _mirrorCooldownEnds[mirror] = now + cooldown;
    if (lastWorkingMirror == mirror) {
      lastWorkingMirror = null;
    }
  }

  void markMirrorWorking(String mirror) {
    _mirrorCooldownEnds.remove(mirror);
    lastWorkingMirror = mirror;
  }
}

class HttpRequestStateRegistry {
  static const Duration defaultFailoverAttemptTimeout = Duration(seconds: 12);
  static const Duration defaultMirrorFailureCooldown = Duration(minutes: 3);

  static final Map<String, HttpExtensionRequestState> _statesByExtensionUid =
      <String, HttpExtensionRequestState>{};

  static HttpClock clock = const SystemHttpClock();
  static Duration failoverAttemptTimeout = defaultFailoverAttemptTimeout;
  static Duration mirrorFailureCooldown = defaultMirrorFailureCooldown;

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
    failoverAttemptTimeout = defaultFailoverAttemptTimeout;
    mirrorFailureCooldown = defaultMirrorFailureCooldown;
  }
}
