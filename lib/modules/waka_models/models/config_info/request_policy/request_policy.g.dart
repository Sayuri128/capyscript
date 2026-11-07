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
      rateLimit: json['rateLimit'] == null
          ? null
          : RateLimit.fromJson(json['rateLimit'] as Map<String, dynamic>),
      defaultHeaders:
          (json['defaultHeaders'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          {},
      userAgent: json['userAgent'] as String?,
      mirrors:
          (json['mirrors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$RequestPolicyToJson(RequestPolicy instance) =>
    <String, dynamic>{
      'rateLimit': instance.rateLimit?.toJson(),
      'defaultHeaders': instance.defaultHeaders,
      'userAgent': instance.userAgent,
      'mirrors': instance.mirrors,
    };
