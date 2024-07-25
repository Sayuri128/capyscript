/*
 * Copyright (c) 2024 armatura24
 * All right reserved
 */

import 'package:capyscript/modules/waka_models/models/common/waka_filter_model.dart';
import 'package:capyscript/modules/waka_models/models/filters/filter_selection_type.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:capyscript/modules/waka_models/models/filters/filter_selection_option_model.dart';
import 'package:collection/collection.dart';

part 'filter_selection_model.g.dart';

@JsonSerializable(explicitToJson: true)
class FilterSelectionModel extends WakaFilterModel {
  factory FilterSelectionModel.fromJson(Map<String, dynamic> json) =>
      _$FilterSelectionModelFromJson(json);

  Map<String, dynamic> toJson() => _$FilterSelectionModelToJson(this);

  final List<FilterSelectionOptionModel> options;
  final FilterSelectionType mode;

  const FilterSelectionModel({
    required super.title,
    required this.options,
    required this.mode,
  });

  @override
  callFunction(String name, {List? ordinalArguments}) {
    throw UnimplementedError();
  }

  @override
  getField(String name) {
    if (name == 'title') {
      return title;
    } else if (name == 'options') {
      return options;
    } else if (name == 'mode') {
      return mode;
    }
  }

  @override
  void setField(String name, value) {
    throw UnimplementedError();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FilterSelectionModel &&
          runtimeType == other.runtimeType &&
          ListEquality().equals(options, other.options) &&
          mode == other.mode &&
          title == other.title;

  @override
  String toString() {
    return 'FilterSelectionModel{title: $title, options: $options, mode: '
        '$mode}';
  }
}
