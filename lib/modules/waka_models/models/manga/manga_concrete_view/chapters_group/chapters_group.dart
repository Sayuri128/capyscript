/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/modules/waka_models/models/common/elements_group_of_concrete.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_concrete_view/chapter/chapter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chapters_group.g.dart';

@JsonSerializable()
class ChaptersGroup extends ElementsGroupOfConcrete<Chapter> {
  factory ChaptersGroup.fromJson(Map<String, dynamic> json) =>
      _$ChaptersGroupFromJson(json);

  Map<String, dynamic> toJson() => _$ChaptersGroupToJson(this);

  const ChaptersGroup(
      {required String title,
      required List<Chapter> elements,
      required Map<String, dynamic> data})
      : super(elements: elements, data: data, title: title);

  ChaptersGroup copyWith({
    String? title,
    List<Chapter>? elements,
    Map<String, dynamic>? data,
  }) {
    return ChaptersGroup(
      title: title ?? this.title,
      elements: elements ?? this.elements,
      data: data ?? this.data,
    );
  }
}
