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

  final String cover;
  final List<String> alternativeTitles;
  final List<String> tags;
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
      {required String uid,
      required this.cover,
      required String title,
      required this.alternativeTitles,
      required String description,
      required this.tags,
      required List<AnimeVideoGroup> groups,
      required this.status})
      : super(uid: uid, groups: groups, description: description, title: title);

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
