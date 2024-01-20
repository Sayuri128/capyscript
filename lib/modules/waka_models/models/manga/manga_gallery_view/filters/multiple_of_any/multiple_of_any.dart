import 'package:capyscript/modules/waka_models/models/manga/manga_gallery_view/filters/gallery_filter.dart';
import 'package:json_annotation/json_annotation.dart';
/*
 * Copyright (c) 2022 armatura24
 * All right reserved
 */

part 'multiple_of_any.g.dart';

@JsonSerializable()
class GalleryFilterMultipleOfAny extends GalleryFilter {
  factory GalleryFilterMultipleOfAny.fromJson(Map<String, dynamic> json) =>
      _$GalleryFilterMultipleOfAnyFromJson(json);

  Map<String, dynamic> toJson() => _$GalleryFilterMultipleOfAnyToJson(this);

  const GalleryFilterMultipleOfAny(
      {required String paramName,
      required GalleryFilterType type,
      required String param})
      : super(paramName: paramName, type: type, param: param);

  @override
  String toString() {
    return 'GalleryFilterMultipleOfAny{}';
  }
}
