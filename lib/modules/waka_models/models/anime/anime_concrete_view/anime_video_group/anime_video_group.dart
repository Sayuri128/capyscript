import 'package:capyscript/modules/waka_models/models/anime/anime_concrete_view/anime_video/anime_video.dart';
import 'package:capyscript/modules/waka_models/models/common/elements_group_of_concrete.dart';
import 'package:json_annotation/json_annotation.dart';
/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

part 'anime_video_group.g.dart';

@JsonSerializable()
class AnimeVideoGroup extends ElementsGroupOfConcrete<AnimeVideo> {
  factory AnimeVideoGroup.fromJson(Map<String, dynamic> json) =>
      _$AnimeVideoGroupFromJson(json);

  Map<String, dynamic> toJson() => _$AnimeVideoGroupToJson(this);

  const AnimeVideoGroup(
      {required String title,
      required List<AnimeVideo> elements,
      required Map<String, dynamic> data})
      : super(elements: elements, data: data, title: title);

  AnimeVideoGroup copyWith(
      {String? title, List<AnimeVideo>? elements, Map<String, dynamic>? data}) {
    return AnimeVideoGroup(
        title: title ?? this.title,
        elements: elements ?? this.elements,
        data: data ?? this.data);
  }
}
