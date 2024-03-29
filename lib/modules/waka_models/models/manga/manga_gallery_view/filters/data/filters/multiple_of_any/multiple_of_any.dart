import 'package:capyscript/modules/waka_models/models/config_info/config_info.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_gallery_view/filters/data/filters/filter_data.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_gallery_view/filters/gallery_filter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'multiple_of_any.g.dart';

@JsonSerializable()
class FilterDataMultipleOfAny extends FilterData {
  factory FilterDataMultipleOfAny.fromJson(Map<String, dynamic> json) =>
      _$FilterDataMultipleOfAnyFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$FilterDataMultipleOfAnyToJson(this);
  final List<String> selected;

  const FilterDataMultipleOfAny(
      {required this.selected, required GalleryFilter filter})
      : super(filter: filter);

  @override
  String toString() {
    return 'FilterDataMultipleOfAny{selected: $selected}';
  }
}
