// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chapter _$ChapterFromJson(Map<String, dynamic> json) => Chapter(
      uid: json['uid'] as String,
      title: json['title'] as String,
      timestamp: json['timestamp'] as String?,
      data: json['data'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$ChapterToJson(Chapter instance) => <String, dynamic>{
      'uid': instance.uid,
      'title': instance.title,
      'data': instance.data,
      'timestamp': instance.timestamp,
    };
