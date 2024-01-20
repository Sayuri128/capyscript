import 'package:capyscript/modules/abstract/external_object.dart';
import 'package:json_annotation/json_annotation.dart';
/*
 * Copyright (c) 2022 armatura24
 * All right reserved
 */

part 'pages.g.dart';

@JsonSerializable()
class Pages extends ExternalObject {
  factory Pages.fromJson(Map<String, dynamic> json) => _$PagesFromJson(json);

  Map<String, dynamic> toJson() => _$PagesToJson(this);

  final String chapterUid;
  final List<String> value;

  const Pages({
    required this.chapterUid,
    required this.value,
  });

  @override
  String toString() {
    return 'Pages{chapterUid: $chapterUid, value: $value}';
  }

  @override
  getField(String name) {
    if (name == 'chapterUid') {
      return chapterUid;
    } else if (name == 'value') {
      return value;
    }
  }

  @override
  void setField(String name, value) {}

  @override
  callFunction(String name, {List? ordinalArguments}) {}
}
