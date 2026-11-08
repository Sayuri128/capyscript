import 'package:capyscript/modules/waka_models/models/anime/anime_concrete_view/anime_video/anime_skip_marker.dart';
import 'package:capyscript/modules/waka_models/models/anime/anime_concrete_view/anime_video/anime_video_source.dart';
import 'package:capyscript/modules/waka_models/models/anime/anime_concrete_view/anime_video/anime_video_subtitle.dart';

class AnimeVideoSourceReader {
  static List<AnimeVideoSource> readSources(dynamic value) {
    if (value == null) {
      return const <AnimeVideoSource>[];
    }
    if (value is AnimeVideoSource || value is Map) {
      return [readSource(value)];
    }
    if (value is! Iterable) {
      throw Exception(
          "getVideoSources must return a list of video sources, got ${value.runtimeType}");
    }
    return [
      for (final item in value)
        if (item != null) readSource(item),
    ];
  }

  static AnimeVideoSource readSource(dynamic value) {
    if (value is AnimeVideoSource) {
      return value;
    }
    if (value is! Map) {
      throw Exception(
          "video source must be built with buildAnimeVideoSource or be a map, got ${value.runtimeType}");
    }
    return AnimeVideoSource(
      url: readUrl(value['url'], 'buildAnimeVideoSource'),
      quality: readText(value['quality']),
      format: readFormat(value['format']),
      headers: readHeaders(value['headers']),
      subtitles: readSubtitles(value['subtitles']),
      skip: readSkipMarkers(value['skip']),
      audioLabel: readText(value['audioLabel']),
      preferForDownload: readFlag(value['preferForDownload']),
    );
  }

  static List<AnimeSkipMarker> readSkipMarkers(dynamic value) {
    if (value == null) {
      return const <AnimeSkipMarker>[];
    }
    if (value is AnimeSkipMarker || value is Map) {
      final marker = readSkipMarker(value);
      return marker == null ? const <AnimeSkipMarker>[] : [marker];
    }
    if (value is! Iterable) {
      return const <AnimeSkipMarker>[];
    }
    final markers = <AnimeSkipMarker>[];
    for (final item in value) {
      final marker = readSkipMarker(item);
      if (marker != null) {
        markers.add(marker);
      }
    }
    return markers;
  }

  static AnimeSkipMarker? readSkipMarker(dynamic value) {
    if (value is AnimeSkipMarker) {
      return value;
    }
    if (value is! Map) {
      return null;
    }
    final type = animeSkipTypeNames[readText(value['type'])?.toLowerCase()];
    final start = readSeconds(value['start']);
    final end = readSeconds(value['end']);
    if (type == null || start == null || end == null || end <= start) {
      return null;
    }
    return AnimeSkipMarker(type: type, start: start, end: end);
  }

  static double? readSeconds(dynamic value) {
    double? seconds;
    if (value is num) {
      seconds = value.toDouble();
    } else if (value is String) {
      seconds = double.tryParse(value.trim());
    }
    if (seconds == null || !seconds.isFinite || seconds < 0) {
      return null;
    }
    return seconds;
  }

  static bool readFlag(dynamic value) {
    return value == true;
  }

  static List<AnimeVideoSubtitle> readSubtitles(dynamic value) {
    if (value == null) {
      return const <AnimeVideoSubtitle>[];
    }
    if (value is AnimeVideoSubtitle || value is Map) {
      return [readSubtitle(value)];
    }
    if (value is! Iterable) {
      throw Exception(
          "subtitles must be a list of subtitles, got ${value.runtimeType}");
    }
    return [
      for (final item in value)
        if (item != null) readSubtitle(item),
    ];
  }

  static AnimeVideoSubtitle readSubtitle(dynamic value) {
    if (value is AnimeVideoSubtitle) {
      return value;
    }
    if (value is! Map) {
      throw Exception(
          "subtitle must be built with buildAnimeVideoSubtitle or be a map, got ${value.runtimeType}");
    }
    return AnimeVideoSubtitle(
      url: readUrl(value['url'], 'buildAnimeVideoSubtitle'),
      label: readText(value['label']),
      language: readText(value['language']),
      format: readFormat(value['format']),
      headers: readHeaders(value['headers']),
    );
  }

  static String readUrl(dynamic value, String builderName) {
    if (value is! String || value.trim().isEmpty) {
      throw Exception("$builderName: url is required");
    }
    return value.trim();
  }

  static String? readText(dynamic value) {
    if (value is! String && value is! num) {
      return null;
    }
    final trimmed = value.toString().trim();
    if (trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }

  static String? readFormat(dynamic value) {
    return readText(value)?.toLowerCase();
  }

  static Map<String, String> readHeaders(dynamic value) {
    if (value is! Map) {
      return const <String, String>{};
    }
    final headers = <String, String>{};
    value.forEach((key, headerValue) {
      if (key != null && headerValue != null) {
        headers[key.toString()] = headerValue.toString();
      }
    });
    return headers;
  }
}
