import 'package:capyscript/modules/abstract/external_object.dart';
import 'package:json_annotation/json_annotation.dart';

part 'anime_skip_marker.g.dart';

enum AnimeSkipType {
  @JsonValue('intro')
  intro,
  @JsonValue('outro')
  outro,
  @JsonValue('recap')
  recap,
}

const Map<String, AnimeSkipType> animeSkipTypeNames = {
  'intro': AnimeSkipType.intro,
  'outro': AnimeSkipType.outro,
  'recap': AnimeSkipType.recap,
};

@JsonSerializable()
class AnimeSkipMarker extends ExternalObject {
  factory AnimeSkipMarker.fromJson(Map<String, dynamic> json) =>
      _$AnimeSkipMarkerFromJson(json);

  Map<String, dynamic> toJson() => _$AnimeSkipMarkerToJson(this);

  final AnimeSkipType type;
  final double start;
  final double end;

  const AnimeSkipMarker({
    required this.type,
    required this.start,
    required this.end,
  });

  static AnimeSkipMarker? tryParse(Object? json) {
    if (json is! Map) {
      return null;
    }
    final AnimeSkipType? type = animeSkipTypeNames[json['type']];
    final double? start = _validSeconds(json['start']);
    final double? end = _validSeconds(json['end']);
    if (type == null || start == null || end == null || end <= start) {
      return null;
    }
    return AnimeSkipMarker(type: type, start: start, end: end);
  }

  static double? _validSeconds(Object? value) {
    if (value is! num || !value.isFinite || value < 0) {
      return null;
    }
    return value.toDouble();
  }

  @override
  dynamic callFunction(String name, {List? ordinalArguments}) {}

  @override
  dynamic getField(String name) {
    if (name == 'type') {
      return type.name;
    } else if (name == 'start') {
      return start;
    } else if (name == 'end') {
      return end;
    }
    return null;
  }

  @override
  void setField(String name, value) {}

  @override
  String toString() {
    return 'AnimeSkipMarker{type: ${type.name}, start: $start, end: $end}';
  }
}

class AnimeSkipMarkersJsonConverter
    extends JsonConverter<List<AnimeSkipMarker>, Object?> {
  const AnimeSkipMarkersJsonConverter();

  @override
  List<AnimeSkipMarker> fromJson(Object? json) {
    if (json is! List) {
      return const <AnimeSkipMarker>[];
    }
    final List<AnimeSkipMarker> markers = <AnimeSkipMarker>[];
    for (final Object? item in json) {
      final AnimeSkipMarker? marker = AnimeSkipMarker.tryParse(item);
      if (marker != null) {
        markers.add(marker);
      }
    }
    return markers;
  }

  @override
  List<dynamic> toJson(List<AnimeSkipMarker> object) {
    return object.map((e) => e.toJson()).toList();
  }
}
