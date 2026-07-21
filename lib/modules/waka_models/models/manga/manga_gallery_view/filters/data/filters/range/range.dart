import 'package:capyscript/modules/waka_models/models/config_info/config_info.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_gallery_view/filters/data/filters/filter_data.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_gallery_view/filters/gallery_filter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'range.g.dart';

@JsonSerializable()
class FilterDataRange extends FilterData {
  factory FilterDataRange.fromJson(Map<String, dynamic> json) =>
      _$FilterDataRangeFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FilterDataRangeToJson(this);

  final String? from;
  final String? to;

  const FilterDataRange({
    this.from,
    this.to,
    required GalleryFilter filter,
  }) : super(filter: filter);

  @override
  String toString() {
    return 'FilterDataRange{from: $from, to: $to}';
  }
}
