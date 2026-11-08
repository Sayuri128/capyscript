import 'package:capyscript/modules/abstract/external_object.dart';
import 'package:json_annotation/json_annotation.dart';

part 'anime_video_subtitle.g.dart';

@JsonSerializable()
class AnimeVideoSubtitle extends ExternalObject {
  factory AnimeVideoSubtitle.fromJson(Map<String, dynamic> json) =>
      _$AnimeVideoSubtitleFromJson(json);

  Map<String, dynamic> toJson() => _$AnimeVideoSubtitleToJson(this);

  final String url;
  final String? label;
  final String? language;
  final String? format;
  final Map<String, String> headers;

  const AnimeVideoSubtitle({
    required this.url,
    this.label,
    this.language,
    this.format,
    this.headers = const <String, String>{},
  });

  @override
  dynamic callFunction(String name, {List? ordinalArguments}) {}

  @override
  dynamic getField(String name) {
    if (name == 'url') {
      return url;
    } else if (name == 'label') {
      return label;
    } else if (name == 'language') {
      return language;
    } else if (name == 'format') {
      return format;
    } else if (name == 'headers') {
      return headers;
    }
    return null;
  }

  @override
  void setField(String name, value) {}

  AnimeVideoSubtitle copyWith({
    String? url,
    String? label,
    String? language,
    String? format,
    Map<String, String>? headers,
  }) {
    return AnimeVideoSubtitle(
      url: url ?? this.url,
      label: label ?? this.label,
      language: language ?? this.language,
      format: format ?? this.format,
      headers: headers ?? this.headers,
    );
  }

  @override
  String toString() {
    return 'AnimeVideoSubtitle{url: $url, label: $label, language: $language, format: $format, headers: $headers}';
  }
}
