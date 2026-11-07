import 'package:capyscript/modules/abstract/external_object.dart';
import 'package:capyscript/modules/waka_models/models/anime/anime_concrete_view/anime_video/anime_skip_marker.dart';
import 'package:capyscript/modules/waka_models/models/anime/anime_concrete_view/anime_video/anime_video_subtitle.dart';
import 'package:json_annotation/json_annotation.dart';

part 'anime_video_source.g.dart';

@JsonSerializable(explicitToJson: true)
class AnimeVideoSource extends ExternalObject {
  factory AnimeVideoSource.fromJson(Map<String, dynamic> json) =>
      _$AnimeVideoSourceFromJson(json);

  Map<String, dynamic> toJson() => _$AnimeVideoSourceToJson(this);

  final String url;
  final String? quality;
  final String? format;
  final Map<String, String> headers;
  final List<AnimeVideoSubtitle> subtitles;
  @AnimeSkipMarkersJsonConverter()
  final List<AnimeSkipMarker> skip;
  final String? audioLabel;
  @JsonKey(defaultValue: false)
  final bool preferForDownload;

  const AnimeVideoSource({
    required this.url,
    this.quality,
    this.format,
    this.headers = const <String, String>{},
    this.subtitles = const <AnimeVideoSubtitle>[],
    this.skip = const <AnimeSkipMarker>[],
    this.audioLabel,
    this.preferForDownload = false,
  });

  @override
  dynamic callFunction(String name, {List? ordinalArguments}) {}

  @override
  dynamic getField(String name) {
    if (name == 'url') {
      return url;
    } else if (name == 'quality') {
      return quality;
    } else if (name == 'format') {
      return format;
    } else if (name == 'headers') {
      return headers;
    } else if (name == 'subtitles') {
      return subtitles;
    } else if (name == 'skip') {
      return skip;
    } else if (name == 'audioLabel') {
      return audioLabel;
    } else if (name == 'preferForDownload') {
      return preferForDownload;
    }
    return null;
  }

  @override
  void setField(String name, value) {}

  AnimeVideoSource copyWith({
    String? url,
    String? quality,
    String? format,
    Map<String, String>? headers,
    List<AnimeVideoSubtitle>? subtitles,
    List<AnimeSkipMarker>? skip,
    String? audioLabel,
    bool? preferForDownload,
  }) {
    return AnimeVideoSource(
      url: url ?? this.url,
      quality: quality ?? this.quality,
      format: format ?? this.format,
      headers: headers ?? this.headers,
      subtitles: subtitles ?? this.subtitles,
      skip: skip ?? this.skip,
      audioLabel: audioLabel ?? this.audioLabel,
      preferForDownload: preferForDownload ?? this.preferForDownload,
    );
  }

  @override
  String toString() {
    return 'AnimeVideoSource{url: $url, quality: $quality, format: $format, headers: $headers, subtitles: $subtitles, skip: $skip, audioLabel: $audioLabel, preferForDownload: $preferForDownload}';
  }
}
