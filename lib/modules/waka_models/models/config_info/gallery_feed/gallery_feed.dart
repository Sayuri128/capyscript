import 'package:capyscript/modules/waka_models/models/config_info/lenient_json.dart';
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

  static GalleryFeed? tryParse(Object? json) {
    final Map<String, Object?>? fields = LenientJson.stringKeyedMap(json);
    if (fields == null) {
      return null;
    }
    final Object? id = fields['id'];
    final Object? title = fields['title'];
    if (id is! String || title is! String) {
      return null;
    }
    return GalleryFeed(id: id, title: title);
  }
}

class GalleryFeedsJsonConverter
    extends JsonConverter<List<GalleryFeed>, Object?> {
  const GalleryFeedsJsonConverter();

  @override
  List<GalleryFeed> fromJson(Object? json) {
    if (json is! List) {
      return const <GalleryFeed>[];
    }
    final List<GalleryFeed> feeds = <GalleryFeed>[];
    for (final Object? item in json) {
      final GalleryFeed? feed = GalleryFeed.tryParse(item);
      if (feed != null) {
        feeds.add(feed);
      }
    }
    return feeds;
  }

  @override
  List<dynamic> toJson(List<GalleryFeed> object) {
    return object.map((e) => e.toJson()).toList();
  }
}
