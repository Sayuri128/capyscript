// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_input_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilterInputModel _$FilterInputModelFromJson(Map<String, dynamic> json) =>
    FilterInputModel(
      title: json['title'] as String,
      placeholder: json['placeholder'] as String,
      defaultValue: json['defaultValue'] as String?,
    );

Map<String, dynamic> _$FilterInputModelToJson(FilterInputModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'placeholder': instance.placeholder,
      'defaultValue': instance.defaultValue,
    };
