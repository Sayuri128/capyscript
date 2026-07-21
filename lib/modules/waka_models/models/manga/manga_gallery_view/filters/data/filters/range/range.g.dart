// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'range.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilterDataRange _$FilterDataRangeFromJson(Map<String, dynamic> json) =>
    FilterDataRange(
      from: json['from'] as String?,
      to: json['to'] as String?,
      filter: const GalleryFilterJsonConverter().fromJson(
        json['filter'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$FilterDataRangeToJson(FilterDataRange instance) =>
    <String, dynamic>{
      'filter': const GalleryFilterJsonConverter().toJson(instance.filter),
      'from': instance.from,
      'to': instance.to,
    };
