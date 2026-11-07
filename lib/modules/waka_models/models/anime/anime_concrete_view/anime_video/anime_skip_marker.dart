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
    extends JsonConverter<List<AnimeSkipMarker>, List<dynamic>?> {
  const AnimeSkipMarkersJsonConverter();

  @override
  List<AnimeSkipMarker> fromJson(List<dynamic>? json) {
    if (json == null) {
      return const <AnimeSkipMarker>[];
    }
    return json
        .whereType<Map>()
        .where((e) =>
            animeSkipTypeNames.containsKey(e['type']) &&
            e['start'] is num &&
            e['end'] is num)
        .map((e) => AnimeSkipMarker.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  List<dynamic> toJson(List<AnimeSkipMarker> object) {
    return object.map((e) => e.toJson()).toList();
  }
}
