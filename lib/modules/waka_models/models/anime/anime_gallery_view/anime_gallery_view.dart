/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/modules/waka_models/models/anime/anime_concrete_view/anime_status.dart';
import 'package:capyscript/modules/waka_models/models/common/gallery_view.dart';
import 'package:json_annotation/json_annotation.dart';

part 'anime_gallery_view.g.dart';

@JsonSerializable()
class AnimeGalleryView extends GalleryView {
  factory AnimeGalleryView.fromJson(Map<String, dynamic> json) =>
      _$AnimeGalleryViewFromJson(json);

  Map<String, dynamic> toJson() => _$AnimeGalleryViewToJson(this);

  final String cover;
  final String title;
  final AnimeStatus status;

  @override
  callFunction(String name, {List? ordinalArguments}) {}

  @override
  getField(String name) {
    if (name == 'uid') {
      return uid;
    } else if (name == 'cover') {
      return cover;
    } else if (name == 'title') {
      return title;
    } else if (name == 'data') {
      return data;
    } else if (name == 'status') {
      return status;
    }
  }

  @override
  void setField(String name, value) {}

  const AnimeGalleryView(
      {required String uid,
      required this.cover,
      required this.title,
      required Map<String, dynamic> data,
      required this.status})
      : super(data: data, uid: uid);

  AnimeGalleryView copyWith({
    String? uid,
    String? cover,
    String? title,
    Map<String, dynamic>? data,
    AnimeStatus? status,
  }) {
    return AnimeGalleryView(
      uid: uid ?? this.uid,
      cover: cover ?? this.cover,
      title: title ?? this.title,
      data: data ?? this.data,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'AnimeGalleryView{uid: $uid, cover: $cover, title: $title, status: $status, data: $data}';
  }
}
