abstract class HttpClock {
  const HttpClock();

  Duration now();

  Future<void> wait(Duration duration);
}

class SystemHttpClock extends HttpClock {
  static final Stopwatch _monotonic = Stopwatch()..start();

  const SystemHttpClock();

  @override
  Duration now() => _monotonic.elapsed;

  @override
  Future<void> wait(Duration duration) => Future<void>.delayed(duration);
}
