import 'package:capyscript/modules/waka_models/models/config_info/config_info.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_gallery_view/filters/data/filters/filter_data.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_gallery_view/filters/gallery_filter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'multiple_of_multiple.g.dart';

@JsonSerializable()
class FilterDataMultipleOfMultiple extends FilterData {
  factory FilterDataMultipleOfMultiple.fromJson(Map<String, dynamic> json) =>
      _$FilterDataMultipleOfMultipleFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$FilterDataMultipleOfMultipleToJson(this);
  final List<List<String>> selected;

  const FilterDataMultipleOfMultiple(
      {required this.selected, required GalleryFilter filter})
      : super(filter: filter);

  @override
  String toString() {
    return 'FilterDataMultipleOfMultiple{selected: $selected}';
  }
}
