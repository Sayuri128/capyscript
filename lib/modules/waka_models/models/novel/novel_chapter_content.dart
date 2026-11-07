import 'package:capyscript/modules/abstract/external_object.dart';

class NovelChapterContent extends ExternalObject {
  final String title;
  final String html;

  const NovelChapterContent({this.title = '', required this.html});

  factory NovelChapterContent.fromJson(Map<String, dynamic> json) {
    return NovelChapterContent(
      title: _readString(json['title']),
      html: _readString(json['html']),
    );
  }

  static String _readString(Object? value) {
    if (value == null) {
      return '';
    }
    return value.toString();
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'title': title,
        'html': html,
      };

  @override
  getField(String name) {
    if (name == 'title') {
      return title;
    } else if (name == 'html') {
      return html;
    }
  }

  @override
  void setField(String name, value) {}

  @override
  callFunction(String name, {List? ordinalArguments}) {}

  @override
  String toString() {
    return 'NovelChapterContent{title: $title, html: ${html.length} chars}';
  }
}
