import 'package:json_annotation/json_annotation.dart';
/*

part 'protector_config.g.dart';
 * Copyright (c) 2022 armatura24
 * All right reserved
 */

part 'protector_config.g.dart';

@JsonSerializable()
class ProtectorConfig {
  factory ProtectorConfig.fromJson(Map<String, dynamic> json) =>
      _$ProtectorConfigFromJson(json);
  Map<String, dynamic> toJson() => _$ProtectorConfigToJson(this);

  final String pingUrl;
  final bool needToLogin;
  final bool inAppBrowserInterceptor;
  final String? sessionGroup;

  @JsonKey(fromJson: readPageLoadTimeoutSeconds)
  final int? pageLoadTimeoutSeconds;

  static const int minPageLoadTimeoutSeconds = 5;
  static const int maxPageLoadTimeoutSeconds = 120;

  static int? readPageLoadTimeoutSeconds(Object? value) {
    if (value is! num || !value.isFinite || value != value.truncate()) {
      return null;
    }
    final int seconds = value.toInt();
    if (seconds < minPageLoadTimeoutSeconds ||
        seconds > maxPageLoadTimeoutSeconds) {
      return null;
    }
    return seconds;
  }

  const ProtectorConfig({
    required this.pingUrl,
    required this.needToLogin,
    required this.inAppBrowserInterceptor,
    this.sessionGroup,
    this.pageLoadTimeoutSeconds,
  });
}
