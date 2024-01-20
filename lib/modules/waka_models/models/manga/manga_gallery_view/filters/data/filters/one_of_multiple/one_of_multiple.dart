import 'package:capyscript/modules/waka_models/models/config_info/config_info.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_gallery_view/filters/data/filters/filter_data.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_gallery_view/filters/gallery_filter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'one_of_multiple.g.dart';

@JsonSerializable()
class FilterDataOneOfMultiple extends FilterData {
  factory FilterDataOneOfMultiple.fromJson(Map<String, dynamic> json) =>
      _$FilterDataOneOfMultipleFromJson(json);

  @override
  String toString() {
    return 'FilterDataOneOfMultiple{selected: $selected}';
  }

  @override
  Map<String, dynamic> toJson() => _$FilterDataOneOfMultipleToJson(this);
  final String selected;

  const FilterDataOneOfMultiple(
      {required this.selected, required GalleryFilter filter})
      : super(filter: filter);
}
