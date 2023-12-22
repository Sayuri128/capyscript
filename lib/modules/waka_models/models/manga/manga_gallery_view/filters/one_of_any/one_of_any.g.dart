// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'one_of_any.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GalleryFilterOneOfAny _$GalleryFilterOneOfAnyFromJson(
        Map<String, dynamic> json) =>
    GalleryFilterOneOfAny(
      paramName: json['paramName'] as String,
      param: json['param'] as String,
      type: $enumDecode(_$GalleryFilterTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$GalleryFilterOneOfAnyToJson(
        GalleryFilterOneOfAny instance) =>
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
