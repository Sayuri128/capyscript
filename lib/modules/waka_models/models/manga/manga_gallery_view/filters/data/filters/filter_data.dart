import 'package:capyscript/modules/waka_models/models/config_info/config_info.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_gallery_view/filters/gallery_filter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'filter_data.g.dart';

@JsonSerializable()
class FilterData {

	factory FilterData.fromJson(Map<String, dynamic> json) => _$FilterDataFromJson(json);
	Map<String, dynamic> toJson() => _$FilterDataToJson(this);

  @GalleryFilterJsonConverter()
  final GalleryFilter filter;

  const FilterData({
    required this.filter
  });

  @override
  String toString() {
    return 'FilterData{filter: $filter}';
  }
}
