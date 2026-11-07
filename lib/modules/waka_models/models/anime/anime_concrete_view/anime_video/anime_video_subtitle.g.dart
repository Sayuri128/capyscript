// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anime_video_subtitle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnimeVideoSubtitle _$AnimeVideoSubtitleFromJson(Map<String, dynamic> json) =>
    AnimeVideoSubtitle(
      url: json['url'] as String,
      label: json['label'] as String?,
      language: json['language'] as String?,
      format: json['format'] as String?,
      headers:
          (json['headers'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const <String, String>{},
    );

Map<String, dynamic> _$AnimeVideoSubtitleToJson(AnimeVideoSubtitle instance) =>
    <String, dynamic>{
      'url': instance.url,
      'label': instance.label,
      'language': instance.language,
      'format': instance.format,
      'headers': instance.headers,
    };
