// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anime_skip_marker.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnimeSkipMarker _$AnimeSkipMarkerFromJson(Map<String, dynamic> json) =>
    AnimeSkipMarker(
      type: $enumDecode(_$AnimeSkipTypeEnumMap, json['type']),
      start: (json['start'] as num).toDouble(),
      end: (json['end'] as num).toDouble(),
    );

Map<String, dynamic> _$AnimeSkipMarkerToJson(AnimeSkipMarker instance) =>
    <String, dynamic>{
      'type': _$AnimeSkipTypeEnumMap[instance.type]!,
      'start': instance.start,
      'end': instance.end,
    };

const _$AnimeSkipTypeEnumMap = {
  AnimeSkipType.intro: 'intro',
  AnimeSkipType.outro: 'outro',
  AnimeSkipType.recap: 'recap',
};
