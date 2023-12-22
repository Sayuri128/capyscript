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
    );

Map<String, dynamic> _$MangaGalleryViewToJson(MangaGalleryView instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'data': instance.data,
      'cover': instance.cover,
      'title': instance.title,
    };
