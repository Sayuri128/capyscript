// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multiple_of_multiple.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GalleryFilterMultipleOfMultiple _$GalleryFilterMultipleOfMultipleFromJson(
        Map<String, dynamic> json) =>
    GalleryFilterMultipleOfMultiple(
      values: (json['values'] as List<dynamic>)
          .map((e) => (e as List<dynamic>).map((e) => e as String).toList())
          .toList(),
      paramName: json['paramName'] as String,
      type: $enumDecode(_$GalleryFilterTypeEnumMap, json['type']),
      param: json['param'] as String,
    );

Map<String, dynamic> _$GalleryFilterMultipleOfMultipleToJson(
        GalleryFilterMultipleOfMultiple instance) =>
    <String, dynamic>{
      'paramName': instance.paramName,
      'param': instance.param,
      'type': _$GalleryFilterTypeEnumMap[instance.type]!,
      'values': instance.values,
    };

const _$GalleryFilterTypeEnumMap = {
  GalleryFilterType.MULTIPLE_OF_ANY: 'MULTIPLE_OF_ANY',
  GalleryFilterType.MULTIPLE_OF_MULTIPLE: 'MULTIPLE_OF_MULTIPLE',
  GalleryFilterType.ONE_OF_ANY: 'ONE_OF_ANY',
  GalleryFilterType.ONE_OF_MULTIPLE: 'ONE_OF_MULTIPLE',
  GalleryFilterType.SWITCHER: 'SWITCHER',
};
