import 'dart:async';
import 'dart:collection';

import 'package:capyscript/modules/http/policy/http_clock.dart';

class HttpRateLimiter {
  final int maxRequests;
  final Duration window;
  final HttpClock clock;

  final Queue<Duration> _recentStarts = Queue<Duration>();
  Future<void> _queueTail = Future<void>.value();

  HttpRateLimiter({
    required this.maxRequests,
    required this.window,
    this.clock = const SystemHttpClock(),
  });

  bool matches(int otherMaxRequests, Duration otherWindow) {
    return maxRequests == otherMaxRequests && window == otherWindow;
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
      if (_recentStarts.length < maxRequests) {
        return;
      }
      final Duration freesAt = _recentStarts.first + window;
      await clock.wait(freesAt - currentTime);
    }
  }

  void _dropExpiredStarts(Duration currentTime) {
    while (_recentStarts.isNotEmpty &&
        _recentStarts.first + window <= currentTime) {
      _recentStarts.removeFirst();
    }
  }
}
