import 'package:capyscript/modules/waka_models/models/common/concrete_view.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_concrete_view/chapters_group/chapters_group.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_concrete_view/manga_status.dart';
import 'package:json_annotation/json_annotation.dart';

import 'chapter/chapter.dart';

part 'manga_concrete_view.g.dart';

@JsonSerializable(explicitToJson: true)
class MangaConcreteView extends ConcreteView<ChaptersGroup> {
  factory MangaConcreteView.fromJson(Map<String, dynamic> json) =>
      _$MangaConcreteViewFromJson(json);

  Map<String, dynamic> toJson() => _$MangaConcreteViewToJson(this);

  final String cover;
  final List<String> alternativeTitles;
  final List<String> tags;
  final MangaStatus status;

  @override
  String toString() {
    return 'ConcreteView{cover: $cover, title: $title, description: $description, tags: $tags, groups: $groups}';
  }

  @override
  getField(String name) {
    if (name == 'cover') {
      return cover;
    } else if (name == 'title') {
      return title;
    } else if (name == 'tags') {
      return tags;
    } else if (name == 'groups') {
      return groups;
    } else if (name == 'description') {
      return description;
    } else if (name == 'status') {
      return status;
    } else if (name == 'alternativeTitles') {
      return alternativeTitles;
    }
  }

  @override
  void setField(String name, value) {}

  const MangaConcreteView({
    required String uid,
    required this.cover,
    required String title,
    required this.alternativeTitles,
    required String description,
    required this.tags,
    required this.status,
    required List<ChaptersGroup> groups,
  }) : super(uid: uid, groups: groups, title: title, description: description);

  @override
  callFunction(String name, {List? ordinalArguments}) {}

  MangaConcreteView copyWith(
      {String? uid,
      String? cover,
      String? title,
      String? description,
      List<String>? tags,
      List<ChaptersGroup>? groups,
      List<String>? alternativeTitles,
      MangaStatus? status}) {
    return MangaConcreteView(
        uid: uid ?? this.uid,
        cover: cover ?? this.cover,
        alternativeTitles: alternativeTitles ?? this.alternativeTitles,
        title: title ?? this.title,
        description: description ?? this.description,
        tags: tags ?? this.tags,
        groups: groups ?? this.groups,
        status: status ?? this.status);
  }
}

class ListOfChaptersJsonConverter
    extends JsonConverter<List<Chapter>, List<dynamic>> {
  const ListOfChaptersJsonConverter();

  @override
  List<Chapter> fromJson(List<dynamic> json) {
    return json.map((e) => Chapter.fromJson(e)).toList();
  }

  @override
  List<Map<String, dynamic>> toJson(List<Chapter> object) {
    return object.map((e) => e.toJson()).toList();
  }
}

class ListOfChapterGroupsJsonConverter
    extends JsonConverter<List<ChaptersGroup>, List<dynamic>> {
  const ListOfChapterGroupsJsonConverter();

  @override
  List<ChaptersGroup> fromJson(List json) {
    return json.map((e) => ChaptersGroup.fromJson(e)).toList();
  }

  @override
  List toJson(List<ChaptersGroup> object) {
    return object.map((e) => e.toJson()).toList();
  }
}
