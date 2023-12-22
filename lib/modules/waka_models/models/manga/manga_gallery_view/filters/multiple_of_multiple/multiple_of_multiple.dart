import 'package:capyscript/modules/waka_models/models/manga/manga_gallery_view/filters/gallery_filter.dart';
import 'package:json_annotation/json_annotation.dart';
/*
 * Copyright (c) 2022 armatura24
 * All right reserved
 */


part 'multiple_of_multiple.g.dart';

@JsonSerializable()
class GalleryFilterMultipleOfMultiple extends GalleryFilter {
  factory GalleryFilterMultipleOfMultiple.fromJson(Map<String, dynamic> json) =>
      _$GalleryFilterMultipleOfMultipleFromJson(json);

  Map<String, dynamic> toJson() =>
      _$GalleryFilterMultipleOfMultipleToJson(this);
  List<List<String>> values;

  GalleryFilterMultipleOfMultiple(
      {required this.values,
      required String paramName,
      required GalleryFilterType type,
      required String param})
      : super(
            paramName: paramName,
            type: type,
            param: param);

  @override
  String toString() {
    return 'GalleryFilterMultipleOfMultiple{values: $values}';
  }
}
