import 'package:capyscript/modules/waka_models/models/config_info/config_info.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_gallery_view/filters/data/filters/filter_data.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_gallery_view/filters/gallery_filter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'switcher.g.dart';

@JsonSerializable()
class FilterDataSwitcher extends FilterData {
  factory FilterDataSwitcher.fromJson(Map<String, dynamic> json) =>
      _$FilterDataSwitcherFromJson(json);

  @override
  String toString() {
    return 'FilterDataSwitcher{on: $on}';
  }

  @override
  Map<String, dynamic> toJson() => _$FilterDataSwitcherToJson(this);
  final bool on;

  const FilterDataSwitcher({required this.on, required GalleryFilter filter})
      : super(filter: filter);
}
