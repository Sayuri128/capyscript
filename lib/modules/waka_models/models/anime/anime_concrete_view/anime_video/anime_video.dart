/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/modules/waka_models/models/anime/anime_concrete_view/anime_video/anime_view_type.dart';
import 'package:capyscript/modules/waka_models/models/common/element_of_elements_group_of_concrete.dart';
import 'package:json_annotation/json_annotation.dart';

part 'anime_video.g.dart';

@JsonSerializable()
class AnimeVideo extends ElementOfElementsGroupOfConcrete {
  factory AnimeVideo.fromJson(Map<String, dynamic> json) =>
      _$AnimeVideoFromJson(json);

  Map<String, dynamic> toJson() => _$AnimeVideoToJson(this);

  final AnimeVideoType type;
  final String src;
  final String? timestamp;

  const AnimeVideo(
      {required this.type,
      required String uid,
      required this.src,
      required String title,
      required this.timestamp,
      required Map<String, dynamic> data})
      : super(title: title, uid: uid, data: data);

  @override
  callFunction(String name, {List? ordinalArguments}) {}

  @override
  getField(String name) {
    if (name == 'type') {
      return type;
    } else if (name == 'uid') {
      return uid;
    } else if (name == 'src') {
      return src;
    } else if (name == 'title') {
      return timestamp;
    } else if (name == 'timestamp') {
      return timestamp;
    } else if (name == 'data') {
      return data;
    }
  }

  @override
  void setField(String name, value) {}

  AnimeVideo copyWith({
    AnimeVideoType? type,
    String? uid,
    String? src,
    String? title,
    String? timestamp,
    Map<String, dynamic>? data,
  }) {
    return AnimeVideo(
      type: type ?? this.type,
      uid: uid ?? this.uid,
      src: src ?? this.src,
      title: title ?? this.title,
      timestamp: timestamp ?? this.timestamp,
      data: data ?? this.data,
    );
  }
}
