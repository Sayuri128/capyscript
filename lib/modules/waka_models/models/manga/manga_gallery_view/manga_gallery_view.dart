import 'package:capyscript/modules/waka_models/models/common/gallery_view.dart';
import 'package:json_annotation/json_annotation.dart';

part 'manga_gallery_view.g.dart';

@JsonSerializable()
class MangaGalleryView extends GalleryView {
  factory MangaGalleryView.fromJson(Map<String, dynamic> json) =>
      _$MangaGalleryViewFromJson(json);

  Map<String, dynamic> toJson() => _$MangaGalleryViewToJson(this);

  final String cover;
  final String title;

  const MangaGalleryView(
      {required String uid,
      required this.cover,
      required this.title,
      Map<String, dynamic> data = const {}})
      : super(uid: uid, data: data);

  @override
  String toString() {
    return 'GalleryView{uid: $uid, cover: $cover, title: $title}';
  }

  @override
  getField(String name) {
    if (name == 'uid') {
      return uid;
    } else if (name == 'cover') {
      return cover;
    } else if (name == 'title') {
      return title;
    } else if (name == 'data') {
      return data;
    }
  }

  @override
  void setField(String name, value) {}

  @override
  callFunction(String name, {List? ordinalArguments}) {}
}
