import 'package:json_annotation/json_annotation.dart';

part 'gallery_feed.g.dart';

@JsonSerializable()
class GalleryFeed {
  factory GalleryFeed.fromJson(Map<String, dynamic> json) =>
      _$GalleryFeedFromJson(json);

  Map<String, dynamic> toJson() => _$GalleryFeedToJson(this);

  final String id;
  final String title;

  const GalleryFeed({required this.id, required this.title});
}

class GalleryFeedsJsonConverter
    extends JsonConverter<List<GalleryFeed>, List<dynamic>?> {
  const GalleryFeedsJsonConverter();

  @override
  List<GalleryFeed> fromJson(List<dynamic>? json) {
    if (json == null) {
      return const <GalleryFeed>[];
    }
    return json
        .whereType<Map>()
        .where((e) => e['id'] is String && e['title'] is String)
        .map((e) => GalleryFeed.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  List<dynamic> toJson(List<GalleryFeed> object) {
    return object.map((e) => e.toJson()).toList();
  }
}
