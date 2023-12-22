// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'switcher.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilterDataSwitcher _$FilterDataSwitcherFromJson(Map<String, dynamic> json) =>
    FilterDataSwitcher(
      on: json['on'] as bool,
      filter: const GalleryFilterJsonConverter()
          .fromJson(json['filter'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FilterDataSwitcherToJson(FilterDataSwitcher instance) =>
    <String, dynamic>{
      'filter': const GalleryFilterJsonConverter().toJson(instance.filter),
      'on': instance.on,
    };
