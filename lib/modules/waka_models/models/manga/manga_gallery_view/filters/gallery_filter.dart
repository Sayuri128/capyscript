/*

part 'gallery_filter.g.dart';
 * Copyright (c) 2022 armatura24
 * All right reserved
 */

abstract class GalleryFilter {
  final String paramName;
  final String param;
  final GalleryFilterType type;

  const GalleryFilter(
      {required this.paramName, required this.param, required this.type});

  @override
  String toString() {
    return 'GalleryFilter{paramName: $paramName, param: $param, type: $type}';
  }
}

enum GalleryFilterType {
  MULTIPLE_OF_ANY,
  MULTIPLE_OF_MULTIPLE,
  ONE_OF_ANY,
  ONE_OF_MULTIPLE,
  SWITCHER
}
