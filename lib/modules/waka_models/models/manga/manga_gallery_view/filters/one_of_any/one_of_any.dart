import 'package:capyscript/modules/waka_models/models/manga/manga_gallery_view/filters/gallery_filter.dart';
import 'package:json_annotation/json_annotation.dart';
/*
 * Copyright (c) 2022 armatura24
 * All right reserved
 */

part 'one_of_any.g.dart';

@JsonSerializable()
class GalleryFilterOneOfAny extends GalleryFilter {
  factory GalleryFilterOneOfAny.fromJson(Map<String, dynamic> json) =>
      _$GalleryFilterOneOfAnyFromJson(json);

  Map<String, dynamic> toJson() => _$GalleryFilterOneOfAnyToJson(this);

  const GalleryFilterOneOfAny({
    required String paramName,
    required String param,
    required GalleryFilterType type,
  }) : super(paramName: paramName, type: type, param: param);

  @override
  String toString() {
    return 'GalleryFilterOneOfAny{}';
  }
}
