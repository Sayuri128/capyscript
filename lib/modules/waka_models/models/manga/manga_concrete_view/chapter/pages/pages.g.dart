// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pages.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pages _$PagesFromJson(Map<String, dynamic> json) => Pages(
      chapterUid: json['chapterUid'] as String,
      value: (json['value'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$PagesToJson(Pages instance) => <String, dynamic>{
      'chapterUid': instance.chapterUid,
      'value': instance.value,
    };
