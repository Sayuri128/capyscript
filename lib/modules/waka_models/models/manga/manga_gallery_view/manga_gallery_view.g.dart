// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manga_gallery_view.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MangaGalleryView _$MangaGalleryViewFromJson(Map<String, dynamic> json) =>
    MangaGalleryView(
      uid: json['uid'] as String,
      cover: json['cover'] as String,
      title: json['title'] as String,
      data: json['data'] as Map<String, dynamic>? ?? const {},
      status: $enumDecodeNullable(_$MangaStatusEnumMap, json['status']),
      subtitle: json['subtitle'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          [],
      year: (json['year'] as num?)?.toInt(),
      rating: json['rating'] as num?,
      latestChapter: json['latestChapter'] as String?,
    );

Map<String, dynamic> _$MangaGalleryViewToJson(MangaGalleryView instance) =>
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
      'status': _$MangaStatusEnumMap[instance.status],
    };

const _$MangaStatusEnumMap = {
  MangaStatus.RELEASED: 'RELEASED',
  MangaStatus.ONGOING: 'ONGOING',
  MangaStatus.PAUSED: 'PAUSED',
  MangaStatus.ANNOUNCE: 'ANNOUNCE',
  MangaStatus.CANCELED: 'CANCELED',
  MangaStatus.UNDEFINED: 'UNDEFINED',
};
