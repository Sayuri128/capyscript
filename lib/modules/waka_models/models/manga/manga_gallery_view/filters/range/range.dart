import 'package:capyscript/modules/waka_models/models/manga/manga_gallery_view/filters/gallery_filter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'range.g.dart';

@JsonSerializable()
class GalleryFilterRange extends GalleryFilter {
  factory GalleryFilterRange.fromJson(Map<String, dynamic> json) =>
      _$GalleryFilterRangeFromJson(json);

  Map<String, dynamic> toJson() => _$GalleryFilterRangeToJson(this);

  final String paramMin;
  final String paramMax;
  final num? min;
  final num? max;

  const GalleryFilterRange({
    required this.paramMin,
    required this.paramMax,
    this.min,
    this.max,
    required String paramName,
    required GalleryFilterType type,
    required String param,
  }) : super(paramName: paramName, type: type, param: param);

  @override
  String toString() {
    return 'GalleryFilterRange{paramMin: $paramMin, paramMax: $paramMax, min: $min, max: $max}';
  }
}
