import 'package:json_annotation/json_annotation.dart';

part 'download_config.g.dart';

@JsonSerializable()
class DownloadConfig {
  factory DownloadConfig.fromJson(Map<String, dynamic> json) =>
      _$DownloadConfigFromJson(json);

  Map<String, dynamic> toJson() => _$DownloadConfigToJson(this);

  final int pageDelayMs;
  final int chapterDelayMs;

  const DownloadConfig({
    this.pageDelayMs = 0,
    this.chapterDelayMs = 0,
  });
}
