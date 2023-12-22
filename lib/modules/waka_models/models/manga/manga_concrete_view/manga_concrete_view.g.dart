// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manga_concrete_view.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MangaConcreteView _$MangaConcreteViewFromJson(Map<String, dynamic> json) =>
    MangaConcreteView(
      uid: json['uid'] as String,
      cover: json['cover'] as String,
      title: json['title'] as String,
      alternativeTitles: (json['alternativeTitles'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      description: json['description'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      status: $enumDecode(_$MangaStatusEnumMap, json['status']),
      groups: (json['groups'] as List<dynamic>)
          .map((e) => ChaptersGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MangaConcreteViewToJson(MangaConcreteView instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'groups': instance.groups,
      'title': instance.title,
      'description': instance.description,
      'cover': instance.cover,
      'alternativeTitles': instance.alternativeTitles,
      'tags': instance.tags,
      'status': _$MangaStatusEnumMap[instance.status]!,
    };

const _$MangaStatusEnumMap = {
  MangaStatus.RELEASED: 'RELEASED',
  MangaStatus.ONGOING: 'ONGOING',
  MangaStatus.PAUSED: 'PAUSED',
  MangaStatus.ANNOUNCE: 'ANNOUNCE',
  MangaStatus.CANCELED: 'CENCELED',
  MangaStatus.UNDEFINED: 'UNDEFINED',
};
