// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'range.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GalleryFilterRange _$GalleryFilterRangeFromJson(Map<String, dynamic> json) =>
    GalleryFilterRange(
      paramMin: json['paramMin'] as String,
      paramMax: json['paramMax'] as String,
      min: json['min'] as num?,
      max: json['max'] as num?,
      paramName: json['paramName'] as String,
      type: $enumDecode(_$GalleryFilterTypeEnumMap, json['type']),
      param: json['param'] as String,
    );

Map<String, dynamic> _$GalleryFilterRangeToJson(GalleryFilterRange instance) =>
    <String, dynamic>{
      'paramName': instance.paramName,
      'param': instance.param,
      'type': _$GalleryFilterTypeEnumMap[instance.type]!,
      'paramMin': instance.paramMin,
      'paramMax': instance.paramMax,
      'min': instance.min,
      'max': instance.max,
    };

const _$GalleryFilterTypeEnumMap = {
  GalleryFilterType.MULTIPLE_OF_ANY: 'MULTIPLE_OF_ANY',
  GalleryFilterType.MULTIPLE_OF_MULTIPLE: 'MULTIPLE_OF_MULTIPLE',
  GalleryFilterType.ONE_OF_ANY: 'ONE_OF_ANY',
  GalleryFilterType.ONE_OF_MULTIPLE: 'ONE_OF_MULTIPLE',
  GalleryFilterType.SWITCHER: 'SWITCHER',
  GalleryFilterType.RANGE: 'RANGE',
};
