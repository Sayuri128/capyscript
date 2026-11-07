import 'dart:async';
import 'dart:collection';

import 'package:capyscript/modules/http/policy/http_clock.dart';

class HttpRateLimit {
  final int maxRequests;
  final Duration window;

  const HttpRateLimit({required this.maxRequests, required this.window});

  bool get isEnforceable => maxRequests > 0 && window > Duration.zero;

  @override
  bool operator ==(Object other) {
    return other is HttpRateLimit &&
        other.maxRequests == maxRequests &&
        other.window == window;
  }

  @override
  int get hashCode => Object.hash(maxRequests, window);

  @override
  String toString() => 'HttpRateLimit($maxRequests per $window)';
}

class _DeclaredRateLimit {
  final WeakReference<Object>? owner;
  HttpRateLimit limit;

  _DeclaredRateLimit({required this.owner, required this.limit});

  bool get isLive => owner == null || owner!.target != null;

  bool isOwnedBy(Object candidate) => identical(owner?.target, candidate);
}

class HttpRateLimiter {
  final HttpClock clock;

  final List<_DeclaredRateLimit> _declaredLimits = <_DeclaredRateLimit>[];
  final Queue<Duration> _recentStarts = Queue<Duration>();
  Duration _longestWindowSeen = Duration.zero;
  Future<void> _queueTail = Future<void>.value();

  HttpRateLimiter({
    required int maxRequests,
    required Duration window,
    this.clock = const SystemHttpClock(),
  }) {
    final HttpRateLimit limit = HttpRateLimit(
      maxRequests: maxRequests,
      window: window,
    );
    _declaredLimits.add(_DeclaredRateLimit(owner: null, limit: limit));
    _rememberWindow(limit);
  }

  HttpRateLimiter.shared({this.clock = const SystemHttpClock()});

  List<HttpRateLimit> get activeLimits {
    _dropReleasedLimits();
    return <HttpRateLimit>[
      for (final _DeclaredRateLimit declared in _declaredLimits)
        if (declared.limit.isEnforceable) declared.limit,
    ];
  }

  bool get isActive => activeLimits.isNotEmpty;

  void declare(Object owner, HttpRateLimit? limit) {
    _dropReleasedLimits();
    final int existingIndex = _declaredLimits.indexWhere(
      (_DeclaredRateLimit declared) => declared.isOwnedBy(owner),
    );
    if (limit == null || !limit.isEnforceable) {
      if (existingIndex >= 0) {
        _declaredLimits.removeAt(existingIndex);
      }
      return;
    }
    _rememberWindow(limit);
    if (existingIndex >= 0) {
      _declaredLimits[existingIndex].limit = limit;
      return;
    }
    _declaredLimits.add(
      _DeclaredRateLimit(owner: WeakReference<Object>(owner), limit: limit),
    );
  }

  Future<void> acquire() async {
    final Future<void> previousTurn = _queueTail;
    final Completer<void> turnFinished = Completer<void>();
    _queueTail = turnFinished.future;
    await previousTurn;
    try {
      await _waitForFreeSlot();
      _recentStarts.addLast(clock.now());
    } finally {
      turnFinished.complete();
    }
  }

  Future<void> _waitForFreeSlot() async {
    while (true) {
      final Duration currentTime = clock.now();
      _dropExpiredStarts(currentTime);
      final Duration? freesAt = _latestRelease(activeLimits, currentTime);
      if (freesAt == null) {
        return;
      }
      await clock.wait(freesAt - currentTime);
    }
  }

  Duration? _latestRelease(List<HttpRateLimit> limits, Duration currentTime) {
    Duration? latestRelease;
    for (final HttpRateLimit limit in limits) {
      final Duration? release = _releaseFor(limit, currentTime);
      if (release != null &&
          (latestRelease == null || release > latestRelease)) {
        latestRelease = release;
      }
    }
    return latestRelease;
  }

  Duration? _releaseFor(HttpRateLimit limit, Duration currentTime) {
    final List<Duration> startsInWindow = <Duration>[
      for (final Duration start in _recentStarts)
        if (start + limit.window > currentTime) start,
    ];
    if (startsInWindow.length < limit.maxRequests) {
      return null;
    }
    final Duration blockingStart =
        startsInWindow[startsInWindow.length - limit.maxRequests];
    return blockingStart + limit.window;
  }

  void _dropExpiredStarts(Duration currentTime) {
    while (_recentStarts.isNotEmpty &&
        _recentStarts.first + _longestWindowSeen <= currentTime) {
      _recentStarts.removeFirst();
    }
  }

  void _rememberWindow(HttpRateLimit limit) {
    if (limit.window > _longestWindowSeen) {
      _longestWindowSeen = limit.window;
    }
  }

  void _dropReleasedLimits() {
    _declaredLimits.removeWhere(
      (_DeclaredRateLimit declared) => !declared.isLive,
    );
  }
}
