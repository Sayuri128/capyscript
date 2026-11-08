import 'package:capyscript/modules/waka_models/anime/anime_video_source_reader.dart';
import 'package:capyscript/modules/waka_models/models/audio/audio_marker.dart';
import 'package:capyscript/modules/waka_models/models/audio/audio_track_source.dart';

class AudioSourceReader {
  static const String builderName = 'buildAudioSource';

  static List<AudioTrackSource> readSources(dynamic value) {
    if (value == null) {
      return const <AudioTrackSource>[];
    }
    if (value is AudioTrackSource || value is Map) {
      return [readSource(value)];
    }
    if (value is! Iterable) {
      throw FormatException(
          'getAudioSources must return a list of audio sources, got ${value.runtimeType}');
    }
    return [
      for (final item in value)
        if (item != null) readSource(item),
    ];
  }

  static AudioTrackSource readSource(dynamic value) {
    if (value is AudioTrackSource) {
      return value;
    }
    if (value is! Map) {
      throw FormatException(
          'audio source must be built with buildAudioSource or be a map, got ${value.runtimeType}');
    }
    return build(
      url: value['url'],
      format: value['format'],
      quality: value['quality'],
      headers: value['headers'],
      duration: value['duration'],
      markers: value['markers'],
    );
  }

  static AudioTrackSource build({
    required dynamic url,
    dynamic format,
    dynamic quality,
    dynamic headers,
    dynamic duration,
    dynamic markers,
  }) {
    return AudioTrackSource(
      url: AnimeVideoSourceReader.readUrl(url, builderName),
      format: AnimeVideoSourceReader.readFormat(format),
      quality: AnimeVideoSourceReader.readText(quality),
      headers: AnimeVideoSourceReader.readHeaders(headers),
      duration: readDuration(duration),
      markers: readMarkers(markers),
    );
  }

  static double? readDuration(dynamic value) {
    final double? seconds = AudioMarker.readSeconds(value);
    if (seconds == null || seconds <= 0) {
      return null;
    }
    return seconds;
  }

  static List<AudioMarker> readMarkers(dynamic value) {
    if (value == null) {
      return const <AudioMarker>[];
    }
    if (value is AudioMarker || value is Map) {
      final AudioMarker? marker = AudioMarker.tryParse(value);
      if (marker == null) {
        return const <AudioMarker>[];
      }
      return [marker];
    }
    if (value is! Iterable) {
      return const <AudioMarker>[];
    }
    final List<AudioMarker> markers = <AudioMarker>[];
    for (final item in value) {
      final AudioMarker? marker = AudioMarker.tryParse(item);
      if (marker != null) {
        markers.add(marker);
      }
    }
    markers.sort((AudioMarker a, AudioMarker b) => a.start.compareTo(b.start));
    return markers;
  }
}
