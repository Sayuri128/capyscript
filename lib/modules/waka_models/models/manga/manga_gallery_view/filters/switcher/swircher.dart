import 'package:capyscript/modules/waka_models/models/manga/manga_gallery_view/filters/gallery_filter.dart';
import 'package:json_annotation/json_annotation.dart';
/*
 * Copyright (c) 2022 armatura24
 * All right reserved
 */


part 'swircher.g.dart';

@JsonSerializable()
class GalleryFilterSwitcher extends GalleryFilter {
  factory GalleryFilterSwitcher.fromJson(Map<String, dynamic> json) =>
      _$GalleryFilterSwitcherFromJson(json);

  Map<String, dynamic> toJson() => _$GalleryFilterSwitcherToJson(this);
  final String onValue;
  final String offValue;

  GalleryFilterSwitcher(
      {required this.onValue,
      required this.offValue,
      required GalleryFilterType type,
      required String paramName,
      required String param})
      : super(paramName: paramName, type: type, param: param);

  @override
  String toString() {
    return 'GalleryFilterSwitcher{onValue: $onValue, offValue: $offValue}';
  }
}
