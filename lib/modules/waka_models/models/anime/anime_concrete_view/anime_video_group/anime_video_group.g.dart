// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anime_video_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnimeVideoGroup _$AnimeVideoGroupFromJson(Map<String, dynamic> json) =>
    AnimeVideoGroup(
      title: json['title'] as String,
      elements: (json['elements'] as List<dynamic>)
          .map((e) => AnimeVideo.fromJson(e as Map<String, dynamic>))
          .toList(),
      data: json['data'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$AnimeVideoGroupToJson(AnimeVideoGroup instance) =>
    <String, dynamic>{
      'title': instance.title,
      'elements': instance.elements,
      'data': instance.data,
    };
