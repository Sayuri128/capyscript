// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anime_video_source.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnimeVideoSource _$AnimeVideoSourceFromJson(Map<String, dynamic> json) =>
    AnimeVideoSource(
      url: json['url'] as String,
      quality: json['quality'] as String?,
      format: json['format'] as String?,
      headers:
          (json['headers'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const <String, String>{},
      subtitles:
          (json['subtitles'] as List<dynamic>?)
              ?.map(
                (e) => AnimeVideoSubtitle.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <AnimeVideoSubtitle>[],
    );

Map<String, dynamic> _$AnimeVideoSourceToJson(AnimeVideoSource instance) =>
    <String, dynamic>{
      'url': instance.url,
      'quality': instance.quality,
      'format': instance.format,
      'headers': instance.headers,
      'subtitles': instance.subtitles.map((e) => e.toJson()).toList(),
    };
