// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DownloadConfig _$DownloadConfigFromJson(Map<String, dynamic> json) =>
    DownloadConfig(
      pageDelayMs: (json['pageDelayMs'] as num?)?.toInt() ?? 0,
      chapterDelayMs: (json['chapterDelayMs'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$DownloadConfigToJson(DownloadConfig instance) =>
    <String, dynamic>{
      'pageDelayMs': instance.pageDelayMs,
      'chapterDelayMs': instance.chapterDelayMs,
    };
