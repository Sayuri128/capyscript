import 'package:capyscript/modules/abstract/external_object.dart';

class AudioMarker extends ExternalObject {
  final String title;
  final double start;

  const AudioMarker({required this.title, required this.start});

  static AudioMarker? tryParse(Object? json) {
    if (json is AudioMarker) {
      return json;
    }
    if (json is! Map) {
      return null;
    }
    final double? start = readSeconds(json['start']);
    if (start == null) {
      return null;
    }
    final Object? title = json['title'];
    return AudioMarker(
      title: title == null ? '' : title.toString().trim(),
      start: start,
    );
  }

  static double? readSeconds(Object? value) {
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

  Map<String, dynamic> toJson() => <String, dynamic>{
        'title': title,
        'start': start,
      };

  @override
  dynamic getField(String name) {
    if (name == 'title') {
      return title;
    } else if (name == 'start') {
      return start;
    }
    return null;
  }

  @override
  void setField(String name, value) {}

  @override
  dynamic callFunction(String name, {List? ordinalArguments}) {}

  @override
  bool operator ==(Object other) {
    return other is AudioMarker && other.title == title && other.start == start;
  }

  @override
  int get hashCode => Object.hash(title, start);

  @override
  String toString() {
    return 'AudioMarker{title: $title, start: $start}';
  }
}
