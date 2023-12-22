// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anime_concrete_view.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnimeConcreteView _$AnimeConcreteViewFromJson(Map<String, dynamic> json) =>
    AnimeConcreteView(
      uid: json['uid'] as String,
      cover: json['cover'] as String,
      title: json['title'] as String,
      alternativeTitles: (json['alternativeTitles'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      description: json['description'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      groups: (json['groups'] as List<dynamic>)
          .map((e) => AnimeVideoGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: $enumDecode(_$AnimeStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$AnimeConcreteViewToJson(AnimeConcreteView instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'groups': instance.groups,
      'title': instance.title,
      'description': instance.description,
      'cover': instance.cover,
      'alternativeTitles': instance.alternativeTitles,
      'tags': instance.tags,
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
