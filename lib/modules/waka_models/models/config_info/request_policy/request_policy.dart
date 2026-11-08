import 'package:capyscript/modules/waka_models/models/config_info/lenient_json.dart';
import 'package:json_annotation/json_annotation.dart';

part 'request_policy.g.dart';

@JsonSerializable()
class RateLimit {
  static const Duration maxWindow = Duration(days: 1);

  factory RateLimit.fromJson(Map<String, dynamic> json) =>
      _$RateLimitFromJson(json);

  Map<String, dynamic> toJson() => _$RateLimitToJson(this);

  final int requests;
  final num perSeconds;

  const RateLimit({required this.requests, required this.perSeconds});

  static RateLimit? tryParse(Object? json) {
    final Map<String, Object?>? fields = LenientJson.stringKeyedMap(json);
    if (fields == null) {
      return null;
    }
    final Object? requests = fields['requests'];
    final Object? perSeconds = fields['perSeconds'];
    if (requests is! num || !requests.isFinite || requests < 1) {
      return null;
    }
    if (perSeconds is! num || !perSeconds.isFinite || perSeconds <= 0) {
      return null;
    }
    return RateLimit(requests: requests.toInt(), perSeconds: perSeconds);
  }

  Duration get window {
    if (!perSeconds.isFinite || perSeconds >= maxWindow.inSeconds) {
      return maxWindow;
    }
    return Duration(
      microseconds: (perSeconds * Duration.microsecondsPerSecond).round(),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class RequestPolicy {
  factory RequestPolicy.fromJson(Map<String, dynamic> json) =>
      _$RequestPolicyFromJson(json);

  Map<String, dynamic> toJson() => _$RequestPolicyToJson(this);

  @RateLimitJsonConverter()
  final RateLimit? rateLimit;
  @StringMapJsonConverter()
  final Map<String, String> defaultHeaders;
  @OptionalStringJsonConverter()
  final String? userAgent;
  @StringListJsonConverter()
  final List<String> mirrors;

  const RequestPolicy({
    this.rateLimit,
    this.defaultHeaders = const <String, String>{},
    this.userAgent,
    this.mirrors = const <String>[],
  });

  static RequestPolicy? tryParse(Object? json) {
    final Map<String, Object?>? fields = LenientJson.stringKeyedMap(json);
    if (fields == null) {
      return null;
    }
    return RequestPolicy.fromJson(fields);
  }
}

class RequestPolicyJsonConverter
    extends JsonConverter<RequestPolicy?, Object?> {
  const RequestPolicyJsonConverter();

  @override
  RequestPolicy? fromJson(Object? json) => RequestPolicy.tryParse(json);

  @override
  Object? toJson(RequestPolicy? object) => object?.toJson();
}

class RateLimitJsonConverter extends JsonConverter<RateLimit?, Object?> {
  const RateLimitJsonConverter();

  @override
  RateLimit? fromJson(Object? json) => RateLimit.tryParse(json);

  @override
  Object? toJson(RateLimit? object) => object?.toJson();
}

class StringMapJsonConverter
    extends JsonConverter<Map<String, String>, Object?> {
  const StringMapJsonConverter();

  @override
  Map<String, String> fromJson(Object? json) {
    final Map<String, Object?>? fields = LenientJson.stringKeyedMap(json);
    if (fields == null) {
      return const <String, String>{};
    }
    final Map<String, String> strings = <String, String>{};
    fields.forEach((String key, Object? value) {
      if (value is String) {
        strings[key] = value;
      }
    });
    return strings;
  }

  @override
  Object? toJson(Map<String, String> object) => object;
}

class StringListJsonConverter extends JsonConverter<List<String>, Object?> {
  const StringListJsonConverter();

  @override
  List<String> fromJson(Object? json) {
    if (json is! List) {
      return const <String>[];
    }
    return json.whereType<String>().toList();
  }

  @override
  Object? toJson(List<String> object) => object;
}

class OptionalStringJsonConverter extends JsonConverter<String?, Object?> {
  const OptionalStringJsonConverter();

  @override
  String? fromJson(Object? json) => json is String ? json : null;

  @override
  Object? toJson(String? object) => object;
}
