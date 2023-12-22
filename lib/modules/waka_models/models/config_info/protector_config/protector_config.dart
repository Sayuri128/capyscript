import 'package:json_annotation/json_annotation.dart';
/*

part 'protector_config.g.dart';
 * Copyright (c) 2022 armatura24
 * All right reserved
 */

part 'protector_config.g.dart';

@JsonSerializable()
class ProtectorConfig {

	factory ProtectorConfig.fromJson(Map<String, dynamic> json) => _$ProtectorConfigFromJson(json);
	Map<String, dynamic> toJson() => _$ProtectorConfigToJson(this);

  final String pingUrl;
  final bool needToLogin;
  final bool inAppBrowserInterceptor;

  const ProtectorConfig({
    required this.pingUrl,
    required this.needToLogin,
    required this.inAppBrowserInterceptor,
  });
}
