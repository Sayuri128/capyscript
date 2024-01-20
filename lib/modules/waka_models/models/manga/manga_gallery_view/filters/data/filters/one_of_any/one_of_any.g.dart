// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'one_of_any.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilterDataOneOfAny _$FilterDataOneOfAnyFromJson(Map<String, dynamic> json) =>
    FilterDataOneOfAny(
      selected: json['selected'] as String,
      filter: const GalleryFilterJsonConverter()
          .fromJson(json['filter'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FilterDataOneOfAnyToJson(FilterDataOneOfAny instance) =>
    <String, dynamic>{
      'filter': const GalleryFilterJsonConverter().toJson(instance.filter),
      'selected': instance.selected,
    };
