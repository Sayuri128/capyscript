// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anime_video.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnimeVideo _$AnimeVideoFromJson(Map<String, dynamic> json) => AnimeVideo(
      type: $enumDecode(_$AnimeVideoTypeEnumMap, json['type']),
      uid: json['uid'] as String,
      src: json['src'] as String,
      title: json['title'] as String,
      timestamp: json['timestamp'] as String?,
      data: json['data'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$AnimeVideoToJson(AnimeVideo instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'title': instance.title,
      'data': instance.data,
      'type': _$AnimeVideoTypeEnumMap[instance.type]!,
      'src': instance.src,
      'timestamp': instance.timestamp,
    };

const _$AnimeVideoTypeEnumMap = {
  AnimeVideoType.IFRAME: 'IFRAME',
};
