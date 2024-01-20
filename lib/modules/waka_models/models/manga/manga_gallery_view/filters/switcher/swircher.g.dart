// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swircher.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GalleryFilterSwitcher _$GalleryFilterSwitcherFromJson(
        Map<String, dynamic> json) =>
    GalleryFilterSwitcher(
      onValue: json['onValue'] as String,
      offValue: json['offValue'] as String,
      type: $enumDecode(_$GalleryFilterTypeEnumMap, json['type']),
      paramName: json['paramName'] as String,
      param: json['param'] as String,
    );

Map<String, dynamic> _$GalleryFilterSwitcherToJson(
        GalleryFilterSwitcher instance) =>
    <String, dynamic>{
      'paramName': instance.paramName,
      'param': instance.param,
      'type': _$GalleryFilterTypeEnumMap[instance.type]!,
      'onValue': instance.onValue,
      'offValue': instance.offValue,
    };

const _$GalleryFilterTypeEnumMap = {
  GalleryFilterType.MULTIPLE_OF_ANY: 'MULTIPLE_OF_ANY',
  GalleryFilterType.MULTIPLE_OF_MULTIPLE: 'MULTIPLE_OF_MULTIPLE',
  GalleryFilterType.ONE_OF_ANY: 'ONE_OF_ANY',
  GalleryFilterType.ONE_OF_MULTIPLE: 'ONE_OF_MULTIPLE',
  GalleryFilterType.SWITCHER: 'SWITCHER',
};
