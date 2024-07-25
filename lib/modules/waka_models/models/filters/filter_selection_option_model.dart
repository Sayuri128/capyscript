/*
 * Copyright (c) 2024 armatura24
 * All right reserved
 */

import 'package:capyscript/modules/abstract/external_object.dart';
import 'package:json_annotation/json_annotation.dart';

part 'filter_selection_option_model.g.dart';

@JsonSerializable(explicitToJson: true)
class FilterSelectionOptionModel extends ExternalObject {
  factory FilterSelectionOptionModel.fromJson(Map<String, dynamic> json) =>
      _$FilterSelectionOptionModelFromJson(json);

  Map<String, dynamic> toJson() => _$FilterSelectionOptionModelToJson(this);

  final String title;
  final String value;

  const FilterSelectionOptionModel({
    required this.title,
    required this.value,
  });

  @override
  callFunction(String name, {List? ordinalArguments}) {
    throw UnimplementedError();
  }

  @override
  getField(String name) {
    if (name == 'title') {
      return title;
    } else if (name == 'value') {
      return value;
    }
  }

  @override
  void setField(String name, value) {
    throw UnimplementedError();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FilterSelectionOptionModel &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          value == other.value;

  @override
  int get hashCode => title.hashCode ^ value.hashCode;
}
