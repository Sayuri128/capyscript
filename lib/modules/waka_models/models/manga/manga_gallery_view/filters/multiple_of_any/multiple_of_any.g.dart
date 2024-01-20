// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multiple_of_any.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GalleryFilterMultipleOfAny _$GalleryFilterMultipleOfAnyFromJson(
        Map<String, dynamic> json) =>
    GalleryFilterMultipleOfAny(
      paramName: json['paramName'] as String,
      type: $enumDecode(_$GalleryFilterTypeEnumMap, json['type']),
      param: json['param'] as String,
    );

Map<String, dynamic> _$GalleryFilterMultipleOfAnyToJson(
        GalleryFilterMultipleOfAny instance) =>
    <String, dynamic>{
      'paramName': instance.paramName,
      'param': instance.param,
      'type': _$GalleryFilterTypeEnumMap[instance.type]!,
    };

const _$GalleryFilterTypeEnumMap = {
  GalleryFilterType.MULTIPLE_OF_ANY: 'MULTIPLE_OF_ANY',
  GalleryFilterType.MULTIPLE_OF_MULTIPLE: 'MULTIPLE_OF_MULTIPLE',
  GalleryFilterType.ONE_OF_ANY: 'ONE_OF_ANY',
  GalleryFilterType.ONE_OF_MULTIPLE: 'ONE_OF_MULTIPLE',
  GalleryFilterType.SWITCHER: 'SWITCHER',
};
