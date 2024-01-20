// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anime_gallery_view.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnimeGalleryView _$AnimeGalleryViewFromJson(Map<String, dynamic> json) =>
    AnimeGalleryView(
      uid: json['uid'] as String,
      cover: json['cover'] as String,
      title: json['title'] as String,
      data: json['data'] as Map<String, dynamic>,
      status: $enumDecode(_$AnimeStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$AnimeGalleryViewToJson(AnimeGalleryView instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'data': instance.data,
      'cover': instance.cover,
      'title': instance.title,
      'status': _$AnimeStatusEnumMap[instance.status]!,
    };

const _$AnimeStatusEnumMap = {
  AnimeStatus.RELEASED: 'RELEASED',
  AnimeStatus.ONGOING: 'ONGOING',
  AnimeStatus.PAUSED: 'PAUSED',
  AnimeStatus.ANNOUNCE: 'ANNOUNCE',
  AnimeStatus.CANCELED: 'CANCELED',
  AnimeStatus.UNDEFINED: 'UNDEFINED',
};
