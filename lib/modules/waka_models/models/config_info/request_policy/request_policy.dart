import 'package:json_annotation/json_annotation.dart';

part 'request_policy.g.dart';

@JsonSerializable()
class RateLimit {
  factory RateLimit.fromJson(Map<String, dynamic> json) =>
      _$RateLimitFromJson(json);

  Map<String, dynamic> toJson() => _$RateLimitToJson(this);

  final int requests;
  final num perSeconds;

  const RateLimit({required this.requests, required this.perSeconds});

  Duration get window =>
      Duration(microseconds: (perSeconds * Duration.microsecondsPerSecond).round());
}

@JsonSerializable(explicitToJson: true)
class RequestPolicy {
  factory RequestPolicy.fromJson(Map<String, dynamic> json) =>
      _$RequestPolicyFromJson(json);

  Map<String, dynamic> toJson() => _$RequestPolicyToJson(this);

  final RateLimit? rateLimit;
  @JsonKey(defaultValue: <String, String>{})
  final Map<String, String> defaultHeaders;
  final String? userAgent;
  @JsonKey(defaultValue: <String>[])
  final List<String> mirrors;

  const RequestPolicy({
    this.rateLimit,
    this.defaultHeaders = const <String, String>{},
    this.userAgent,
    this.mirrors = const <String>[],
  });
}
