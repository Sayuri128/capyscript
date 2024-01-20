// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multiple_of_any.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilterDataMultipleOfAny _$FilterDataMultipleOfAnyFromJson(
        Map<String, dynamic> json) =>
    FilterDataMultipleOfAny(
      selected:
          (json['selected'] as List<dynamic>).map((e) => e as String).toList(),
      filter: const GalleryFilterJsonConverter()
          .fromJson(json['filter'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FilterDataMultipleOfAnyToJson(
        FilterDataMultipleOfAny instance) =>
    <String, dynamic>{
      'filter': const GalleryFilterJsonConverter().toJson(instance.filter),
      'selected': instance.selected,
    };
