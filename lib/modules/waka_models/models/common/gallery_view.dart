/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/modules/abstract/external_object.dart';
import 'package:json_annotation/json_annotation.dart';

abstract class GalleryView extends ExternalObject {
  final String uid;
  final Map<String, dynamic> data;
  final String? subtitle;
  @JsonKey(defaultValue: <String>[])
  final List<String> tags;
  final int? year;
  final num? rating;
  final String? latestChapter;

  const GalleryView({
    required this.uid,
    required this.data,
    this.subtitle,
    this.tags = const <String>[],
    this.year,
    this.rating,
    this.latestChapter,
  });

  dynamic getMetadataField(String name) {
    switch (name) {
      case 'subtitle':
        return subtitle;
      case 'tags':
        return tags;
      case 'year':
        return year;
      case 'rating':
        return rating;
      case 'latestChapter':
        return latestChapter;
    }
    return null;
  }
}
