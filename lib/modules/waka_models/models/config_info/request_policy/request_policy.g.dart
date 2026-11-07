// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_policy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RateLimit _$RateLimitFromJson(Map<String, dynamic> json) => RateLimit(
  requests: (json['requests'] as num).toInt(),
  perSeconds: json['perSeconds'] as num,
);

Map<String, dynamic> _$RateLimitToJson(RateLimit instance) => <String, dynamic>{
  'requests': instance.requests,
  'perSeconds': instance.perSeconds,
};

RequestPolicy _$RequestPolicyFromJson(Map<String, dynamic> json) =>
    RequestPolicy(
      rateLimit: const RateLimitJsonConverter().fromJson(json['rateLimit']),
      defaultHeaders: json['defaultHeaders'] == null
          ? const <String, String>{}
          : const StringMapJsonConverter().fromJson(json['defaultHeaders']),
      userAgent: const OptionalStringJsonConverter().fromJson(
        json['userAgent'],
      ),
      mirrors: json['mirrors'] == null
          ? const <String>[]
          : const StringListJsonConverter().fromJson(json['mirrors']),
    );

Map<String, dynamic> _$RequestPolicyToJson(
  RequestPolicy instance,
) => <String, dynamic>{
  'rateLimit': const RateLimitJsonConverter().toJson(instance.rateLimit),
  'defaultHeaders': const StringMapJsonConverter().toJson(
    instance.defaultHeaders,
  ),
  'userAgent': const OptionalStringJsonConverter().toJson(instance.userAgent),
  'mirrors': const StringListJsonConverter().toJson(instance.mirrors),
};
