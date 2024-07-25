// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_selection_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilterSelectionModel _$FilterSelectionModelFromJson(
        Map<String, dynamic> json) =>
    FilterSelectionModel(
      title: json['title'] as String,
      options: (json['options'] as List<dynamic>)
          .map((e) =>
              FilterSelectionOptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      mode: $enumDecode(_$FilterSelectionTypeEnumMap, json['mode']),
    );

Map<String, dynamic> _$FilterSelectionModelToJson(
        FilterSelectionModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'options': instance.options.map((e) => e.toJson()).toList(),
      'mode': _$FilterSelectionTypeEnumMap[instance.mode]!,
    };

const _$FilterSelectionTypeEnumMap = {
  FilterSelectionType.single: 'single',
  FilterSelectionType.multiple: 'multiple',
  FilterSelectionType.sort: 'sort',
};
