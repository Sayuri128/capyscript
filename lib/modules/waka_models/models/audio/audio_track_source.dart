import 'package:capyscript/modules/abstract/external_object.dart';
import 'package:capyscript/modules/waka_models/models/audio/audio_marker.dart';

class AudioTrackSource extends ExternalObject {
  static const String formatMp3 = 'mp3';
  static const String formatM4a = 'm4a';
  static const String formatM4b = 'm4b';
  static const String formatHls = 'hls';

  final String url;
  final String? format;
  final String? quality;
  final Map<String, String> headers;
  final double? duration;
  final List<AudioMarker> markers;

  const AudioTrackSource({
    required this.url,
    this.format,
    this.quality,
    this.headers = const <String, String>{},
    this.duration,
    this.markers = const <AudioMarker>[],
  });

  factory AudioTrackSource.fromJson(Map<String, dynamic> json) {
    return AudioTrackSource(
      url: json['url'].toString(),
      format: json['format'] as String?,
      quality: json['quality'] as String?,
      headers: _readHeaders(json['headers']),
      duration: AudioMarker.readSeconds(json['duration']),
      markers: _readMarkers(json['markers']),
    );
  }

  static Map<String, String> _readHeaders(Object? value) {
    if (value is! Map) {
      return const <String, String>{};
    }
    return value.map(
        (key, headerValue) => MapEntry(key.toString(), headerValue.toString()));
  }

  static List<AudioMarker> _readMarkers(Object? value) {
    if (value is! List) {
      return const <AudioMarker>[];
    }
    final List<AudioMarker> markers = <AudioMarker>[];
    for (final Object? item in value) {
      final AudioMarker? marker = AudioMarker.tryParse(item);
      if (marker != null) {
        markers.add(marker);
      }
    }
    return markers;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'url': url,
        'format': format,
        'quality': quality,
        'headers': headers,
        'duration': duration,
        'markers': markers.map((AudioMarker marker) => marker.toJson()).toList(),
      };

  @override
  dynamic getField(String name) {
    if (name == 'url') {
      return url;
    } else if (name == 'format') {
      return format;
    } else if (name == 'quality') {
      return quality;
    } else if (name == 'headers') {
      return headers;
    } else if (name == 'duration') {
      return duration;
    } else if (name == 'markers') {
      return markers;
    }
    return null;
  }

  @override
  void setField(String name, value) {}

  @override
  dynamic callFunction(String name, {List? ordinalArguments}) {}

  @override
  String toString() {
    return 'AudioTrackSource{url: $url, format: $format, quality: $quality, headers: $headers, duration: $duration, markers: $markers}';
  }
}
