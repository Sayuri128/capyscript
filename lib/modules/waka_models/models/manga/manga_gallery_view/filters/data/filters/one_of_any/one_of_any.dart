import 'package:capyscript/modules/waka_models/models/config_info/config_info.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_gallery_view/filters/data/filters/filter_data.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_gallery_view/filters/gallery_filter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'one_of_any.g.dart';

@JsonSerializable()
class FilterDataOneOfAny extends FilterData {

	factory FilterDataOneOfAny.fromJson(Map<String, dynamic> json) => _$FilterDataOneOfAnyFromJson(json);

  @override
  String toString() {
    return 'FilterDataOneOfAny{selected: $selected}';
  }

  @override
  Map<String, dynamic> toJson() => _$FilterDataOneOfAnyToJson(this);
  final String selected;

  const FilterDataOneOfAny({
    required this.selected,
    required GalleryFilter filter
  }) : super(filter: filter);
}
