import 'package:capyscript/modules/waka_models/models/manga/manga_gallery_view/filters/gallery_filter.dart';
import 'package:json_annotation/json_annotation.dart';
/*
 * Copyright (c) 2022 armatura24
 * All right reserved
 */

part 'one_of_multiple.g.dart';

@JsonSerializable()
class GalleryFilterOneOfMultiple extends GalleryFilter {
  factory GalleryFilterOneOfMultiple.fromJson(Map<String, dynamic> json) =>
      _$GalleryFilterOneOfMultipleFromJson(json);

  Map<String, dynamic> toJson() => _$GalleryFilterOneOfMultipleToJson(this);
  final List<String> values;

  const GalleryFilterOneOfMultiple(
      {required this.values,
      required String paramName,
      required GalleryFilterType type,
      required String param})
      : super(paramName: paramName, type: type, param: param);

  @override
  String toString() {
    return 'GalleryFilterOneOfMultiple{values: $values}';
  }
}
