import 'package:json_annotation/json_annotation.dart';

class ContentKinds {
  static const String anime = 'anime';
  static const String movie = 'movie';
  static const String series = 'series';
  static const String cartoon = 'cartoon';
  static const String dorama = 'dorama';
  static const String documentary = 'documentary';
  static const String manga = 'manga';
  static const String manhwa = 'manhwa';
  static const String manhua = 'manhua';
  static const String comic = 'comic';
  static const String novel = 'novel';
  static const String audiobook = 'audiobook';

  static const List<String> known = <String>[
    anime,
    movie,
    series,
    cartoon,
    dorama,
    documentary,
    manga,
    manhwa,
    manhua,
    comic,
    novel,
    audiobook,
  ];

  static List<String> parse(Object? json) {
    if (json is! List) {
      return const <String>[];
    }
    final List<String> kinds = <String>[];
    for (final Object? item in json) {
      if (item is! String) {
        continue;
      }
      final String kind = item.trim().toLowerCase();
      if (kind.isEmpty || kinds.contains(kind)) {
        continue;
      }
      kinds.add(kind);
    }
    return List<String>.unmodifiable(kinds);
  }
}

class ContentKindsJsonConverter extends JsonConverter<List<String>, Object?> {
  const ContentKindsJsonConverter();

  @override
  List<String> fromJson(Object? json) => ContentKinds.parse(json);

  @override
  Object? toJson(List<String> object) => object;
}
