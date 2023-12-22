import 'package:capyscript/modules/waka_models/models/common/element_of_elements_group_of_concrete.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chapter.g.dart';

@JsonSerializable()
class Chapter extends ElementOfElementsGroupOfConcrete {
  factory Chapter.fromJson(Map<String, dynamic> json) =>
      _$ChapterFromJson(json);

  Map<String, dynamic> toJson() => _$ChapterToJson(this);

  final String? timestamp;

  const Chapter(
      {required String uid,
      required String title,
      this.timestamp,
      required Map<String, dynamic> data})
      : super(data: data, uid: uid, title: title);

  @override
  String toString() {
    return 'Chapter{uid: $uid, title: $title, timestamp: $timestamp, data: $data}';
  }

  @override
  getField(String name) {
    if (name == 'uid') {
      return uid;
    } else if (name == 'title') {
      return title;
    } else if (name == 'timestamp') {
      return timestamp;
    } else if (name == 'data') {
      return data;
    }
  }

  @override
  void setField(String name, value) {}

  @override
  callFunction(String name, {List? ordinalArguments}) {}

  Chapter copyWith({
    String? uid,
    String? title,
    String? timestamp,
    Map<String, dynamic>? data,
  }) {
    return Chapter(
      uid: uid ?? this.uid,
      title: title ?? this.title,
      timestamp: timestamp ?? this.timestamp,
      data: data ?? this.data,
    );
  }
}
