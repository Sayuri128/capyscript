// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'one_of_multiple.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilterDataOneOfMultiple _$FilterDataOneOfMultipleFromJson(
        Map<String, dynamic> json) =>
    FilterDataOneOfMultiple(
      selected: json['selected'] as String,
      filter: const GalleryFilterJsonConverter()
          .fromJson(json['filter'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FilterDataOneOfMultipleToJson(
        FilterDataOneOfMultiple instance) =>
    <String, dynamic>{
      'filter': const GalleryFilterJsonConverter().toJson(instance.filter),
      'selected': instance.selected,
    };
