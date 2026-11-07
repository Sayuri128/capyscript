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
      subtitle: json['subtitle'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          [],
      year: (json['year'] as num?)?.toInt(),
      rating: json['rating'] as num?,
      latestChapter: json['latestChapter'] as String?,
    );

Map<String, dynamic> _$AnimeGalleryViewToJson(AnimeGalleryView instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'data': instance.data,
      'subtitle': instance.subtitle,
      'tags': instance.tags,
      'year': instance.year,
      'rating': instance.rating,
      'latestChapter': instance.latestChapter,
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
