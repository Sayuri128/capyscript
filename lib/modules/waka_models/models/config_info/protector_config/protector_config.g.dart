// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'protector_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProtectorConfig _$ProtectorConfigFromJson(Map<String, dynamic> json) =>
    ProtectorConfig(
      pingUrl: json['pingUrl'] as String,
      needToLogin: json['needToLogin'] as bool,
      inAppBrowserInterceptor: json['inAppBrowserInterceptor'] as bool,
    );

Map<String, dynamic> _$ProtectorConfigToJson(ProtectorConfig instance) =>
    <String, dynamic>{
      'pingUrl': instance.pingUrl,
      'needToLogin': instance.needToLogin,
      'inAppBrowserInterceptor': instance.inAppBrowserInterceptor,
    };
