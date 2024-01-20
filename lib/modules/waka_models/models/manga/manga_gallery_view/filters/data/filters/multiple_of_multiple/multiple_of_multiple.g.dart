// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multiple_of_multiple.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilterDataMultipleOfMultiple _$FilterDataMultipleOfMultipleFromJson(
        Map<String, dynamic> json) =>
    FilterDataMultipleOfMultiple(
      selected: (json['selected'] as List<dynamic>)
          .map((e) => (e as List<dynamic>).map((e) => e as String).toList())
          .toList(),
      filter: const GalleryFilterJsonConverter()
          .fromJson(json['filter'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FilterDataMultipleOfMultipleToJson(
        FilterDataMultipleOfMultiple instance) =>
    <String, dynamic>{
      'filter': const GalleryFilterJsonConverter().toJson(instance.filter),
      'selected': instance.selected,
    };
