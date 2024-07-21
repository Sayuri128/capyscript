import 'package:capyscript/modules/waka_models/models/anime/anime_concrete_view/anime_status.dart';
import 'package:capyscript/modules/waka_models/models/anime/anime_concrete_view/anime_video_group/anime_video_group.dart';
import 'package:capyscript/modules/waka_models/models/common/concrete_view.dart';
import 'package:json_annotation/json_annotation.dart';

/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

part 'anime_concrete_view.g.dart';

@JsonSerializable()
class AnimeConcreteView extends ConcreteView<AnimeVideoGroup> {
  factory AnimeConcreteView.fromJson(Map<String, dynamic> json) =>
      _$AnimeConcreteViewFromJson(json);

  Map<String, dynamic> toJson() => _$AnimeConcreteViewToJson(this);

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
    } else if (name == 'tags') {
      return tags;
    } else if (name == 'alternativeTitles') {
      return alternativeTitles;
    } else if (name == 'description') {
      return description;
    } else if (name == 'groups') {
      return groups;
    } else if (name == 'status') {
      return status;
    }
  }

  @override
  void setField(String name, value) {}

  const AnimeConcreteView(
      {required super.uid,
      required super.cover,
      required super.title,
      required super.alternativeTitles,
      required super.description,
      required super.tags,
      required super.groups,
      required this.status});

  AnimeConcreteView copyWith({
    String? uid,
    String? cover,
    String? title,
    List<String>? alternativeTitles,
    String? description,
    List<String>? tags,
    List<AnimeVideoGroup>? groups,
    AnimeStatus? status,
  }) {
    return AnimeConcreteView(
      uid: uid ?? this.uid,
      cover: cover ?? this.cover,
      title: title ?? this.title,
      alternativeTitles: alternativeTitles ?? this.alternativeTitles,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      groups: groups ?? this.groups,
      status: status ?? this.status,
    );
  }
}
