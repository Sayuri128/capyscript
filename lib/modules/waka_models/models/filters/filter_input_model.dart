/*
 * Copyright (c) 2024 armatura24
 * All right reserved
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:capyscript/modules/waka_models/models/common/waka_filter_model.dart';

part 'filter_input_model.g.dart';

@JsonSerializable()
class FilterInputModel extends WakaFilterModel {
  factory FilterInputModel.fromJson(Map<String, dynamic> json) =>
      _$FilterInputModelFromJson(json);

  Map<String, dynamic> toJson() => _$FilterInputModelToJson(this);

  final String placeholder;
  final String? defaultValue;

  @override
  callFunction(String name, {List? ordinalArguments}) {
    throw UnimplementedError();
  }

  @override
  getField(String name) {
    if (name == 'title') {
      return title;
    } else if (name == 'placeholder') {
      return placeholder;
    } else if (name == 'defaultValue') {
      return defaultValue;
    }
  }

  @override
  void setField(String name, value) {
    throw UnimplementedError();
  }

  const FilterInputModel({
    required super.title,
    required this.placeholder,
    this.defaultValue,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FilterInputModel &&
          runtimeType == other.runtimeType &&
          placeholder == other.placeholder &&
          defaultValue == other.defaultValue;

  @override
  int get hashCode => placeholder.hashCode ^ defaultValue.hashCode;
}
