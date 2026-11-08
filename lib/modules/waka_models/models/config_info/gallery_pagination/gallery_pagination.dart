import 'package:json_annotation/json_annotation.dart';

class GalleryPagination {
  static const int maxPageSize = 500;

  final List<int> pageSizes;
  final int defaultPageSize;

  const GalleryPagination({
    required this.pageSizes,
    required this.defaultPageSize,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
        'pageSizes': pageSizes,
        'defaultPageSize': defaultPageSize,
      };

  static GalleryPagination? tryParse(Object? json) {
    if (json is! Map) {
      return null;
    }
    final List<int> sizes = <int>[];
    final Object? declaredSizes = json['pageSizes'];
    if (declaredSizes is List) {
      for (final Object? item in declaredSizes) {
        final int? size = validPageSize(item);
        if (size != null && !sizes.contains(size)) {
          sizes.add(size);
        }
      }
    }
    if (sizes.isEmpty) {
      return null;
    }
    final int? declaredDefault = validPageSize(json['defaultPageSize']);
    final int defaultSize = declaredDefault != null && sizes.contains(declaredDefault)
        ? declaredDefault
        : sizes.first;
    return GalleryPagination(pageSizes: sizes, defaultPageSize: defaultSize);
  }

  static int? validPageSize(Object? value) {
    if (value is num && value.isFinite && value == value.roundToDouble()) {
      final int size = value.toInt();
      if (size >= 1 && size <= maxPageSize) {
        return size;
      }
      return null;
    }
    if (value is String) {
      return validPageSize(num.tryParse(value.trim()));
    }
    return null;
  }

  int resolve(Object? selected) {
    final int? size = validPageSize(selected);
    if (size != null && pageSizes.contains(size)) {
      return size;
    }
    return defaultPageSize;
  }
}

class GalleryPaginationJsonConverter
    extends JsonConverter<GalleryPagination?, Object?> {
  const GalleryPaginationJsonConverter();

  @override
  GalleryPagination? fromJson(Object? json) => GalleryPagination.tryParse(json);

  @override
  Object? toJson(GalleryPagination? object) => object?.toJson();
}
