// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapters_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChaptersGroup _$ChaptersGroupFromJson(Map<String, dynamic> json) =>
    ChaptersGroup(
      title: json['title'] as String,
      elements: (json['elements'] as List<dynamic>)
          .map((e) => Chapter.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChaptersGroupToJson(ChaptersGroup instance) =>
    <String, dynamic>{
      'title': instance.title,
      'elements': instance.elements,
    };
