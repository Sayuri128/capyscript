import 'package:capyscript/modules/abstract/external_object.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_gallery_view/filters/gallery_filter.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_gallery_view/filters/multiple_of_multiple/multiple_of_multiple.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_gallery_view/filters/one_of_any/one_of_any.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_gallery_view/filters/one_of_multiple/one_of_multiple.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_gallery_view/filters/range/range.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_gallery_view/filters/switcher/swircher.dart';
import 'package:json_annotation/json_annotation.dart';

import '../manga/manga_gallery_view/filters/multiple_of_any/multiple_of_any.dart';
import 'content_kinds/content_kinds.dart';
import 'download_config/download_config.dart';
import 'gallery_feed/gallery_feed.dart';
import 'gallery_pagination/gallery_pagination.dart';
import 'preferences/extension_preference.dart';
import 'protector_config/protector_config.dart';
import 'request_policy/request_policy.dart';

part 'config_info.g.dart';

enum ConfigInfoType {
  @JsonValue(0)
  MANGA,
  @JsonValue(1)
  ANIME,
  @JsonValue(2)
  NOVEL
}

int serializeLocalApiClientType(ConfigInfoType type) {
  switch (type) {
    case ConfigInfoType.MANGA:
      return 0;
    case ConfigInfoType.ANIME:
      return 1;
    case ConfigInfoType.NOVEL:
      return 2;
  }
}

ConfigInfoType deserializeLocalApiClientType(int type) {
  switch (type) {
    case 0:
      return ConfigInfoType.MANGA;
    case 1:
      return ConfigInfoType.ANIME;
    case 2:
      return ConfigInfoType.NOVEL;
  }
  throw FormatException("Unknown ConfigInfo type $type");
}

class ConfigInfoTypeJsonConverter
    extends JsonConverter<ConfigInfoType, Object?> {
  const ConfigInfoTypeJsonConverter();

  @override
  ConfigInfoType fromJson(Object? json) {
    if (json is num && json.isFinite && json == json.toInt()) {
      return deserializeLocalApiClientType(json.toInt());
    }
    throw FormatException("Unknown ConfigInfo type $json");
  }

  @override
  Object? toJson(ConfigInfoType object) => serializeLocalApiClientType(object);
}

@JsonSerializable(explicitToJson: true)
class ConfigInfo extends ExternalObject {
  factory ConfigInfo.fromJson(Map<String, dynamic> json) =>
      _$ConfigInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigInfoToJson(this);

  final String uid;
  final String name;
  final String logoUrl;
  @ConfigInfoTypeJsonConverter()
  final ConfigInfoType type;
  final bool nsfw;
  final String language;
  final int version;

  @GalleryFiltersJsonConverter()
  final List<GalleryFilter> filters;

  @ProtectorConfigJsonConverter()
  final ProtectorConfig? protectorConfig;

  @DownloadConfigJsonConverter()
  final DownloadConfig? downloadConfig;

  final bool searchAvailable;

  @JsonKey(defaultValue: 1)
  final int apiVersion;

  final String? minAppVersion;

  @ExtensionPreferencesJsonConverter()
  final List<ExtensionPreference> preferences;

  @RequestPolicyJsonConverter()
  final RequestPolicy? requestPolicy;

  @GalleryFeedsJsonConverter()
  final List<GalleryFeed> feeds;

  @GalleryPaginationJsonConverter()
  final GalleryPagination? pagination;

  @ContentKindsJsonConverter()
  final List<String> contentKinds;

  @JsonKey(fromJson: readMultiInstance)
  final bool multiInstance;

  static bool readMultiInstance(Object? value) => value == true;

  @override
  getField(String name) {
    if (name == 'name') {
      return this.name;
    } else if (name == 'logoUrl') {
      return logoUrl;
    } else if (name == 'nsfw') {
      return nsfw;
    } else if (name == 'language') {
      return language;
    } else if (name == 'version') {
      return version;
    } else if (name == 'protectorConfig') {
      return protectorConfig;
    } else if (name == 'downloadConfig') {
      return downloadConfig;
    } else if (name == 'searchAvailable') {
      return searchAvailable;
    } else if (name == 'uid') {
      return uid;
    } else if (name == 'apiVersion') {
      return apiVersion;
    } else if (name == 'minAppVersion') {
      return minAppVersion;
    } else if (name == 'contentKinds') {
      return contentKinds;
    } else if (name == 'multiInstance') {
      return multiInstance;
    }
  }

  @override
  void setField(String name, value) {}

  @override
  String toString() {
    return 'ConfigInfo{name: $name, logoUrl: $logoUrl, nsfw: $nsfw, language: $language, version: $version, filters: $filters, protectorConfig: $protectorConfig, searchAvailable: $searchAvailable}';
  }

  const ConfigInfo(
      {required this.name,
      required this.uid,
      required this.logoUrl,
      required this.nsfw,
      required this.language,
      required this.version,
      required this.filters,
      required this.type,
      this.protectorConfig,
      this.downloadConfig,
      required this.searchAvailable,
      this.apiVersion = 1,
      this.minAppVersion,
      this.preferences = const <ExtensionPreference>[],
      this.requestPolicy,
      this.feeds = const <GalleryFeed>[],
      this.pagination,
      this.contentKinds = const <String>[],
      this.multiInstance = false});

  @override
  callFunction(String name, {List? ordinalArguments}) {}
}

class DownloadConfigJsonConverter
    extends JsonConverter<DownloadConfig, Map<String, dynamic>> {
  const DownloadConfigJsonConverter();

  @override
  DownloadConfig fromJson(Map<String, dynamic> json) {
    return DownloadConfig.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(DownloadConfig object) {
    return object.toJson();
  }
}

class ProtectorConfigJsonConverter
    extends JsonConverter<ProtectorConfig, Map<String, dynamic>> {
  const ProtectorConfigJsonConverter();

  @override
  ProtectorConfig fromJson(Map<String, dynamic> json) {
    return ProtectorConfig.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(ProtectorConfig object) {
    return object.toJson();
  }
}

class GalleryFilterJsonConverter
    extends JsonConverter<GalleryFilter, Map<String, dynamic>> {
  const GalleryFilterJsonConverter();

  @override
  GalleryFilter fromJson(Map<String, dynamic> json) {
    if (json["type"] == null) {
      throw Exception();
    }
    final type = GalleryFilterModes.entries
        .firstWhere((element) => element.value == json["type"])
        .key;

    switch (type) {
      case GalleryFilterType.MULTIPLE_OF_ANY:
        return GalleryFilterMultipleOfAny.fromJson(json);
      case GalleryFilterType.MULTIPLE_OF_MULTIPLE:
        return GalleryFilterMultipleOfMultiple.fromJson(json);
      case GalleryFilterType.ONE_OF_ANY:
        return GalleryFilterOneOfAny.fromJson(json);
      case GalleryFilterType.ONE_OF_MULTIPLE:
        return GalleryFilterOneOfMultiple.fromJson(json);
      case GalleryFilterType.SWITCHER:
        return GalleryFilterSwitcher.fromJson(json);
      case GalleryFilterType.RANGE:
        return GalleryFilterRange.fromJson(json);
    }
  }

  @override
  Map<String, dynamic> toJson(GalleryFilter object) {
    if (object is GalleryFilterMultipleOfAny) {
      return object.toJson();
    } else if (object is GalleryFilterMultipleOfMultiple) {
      return object.toJson();
    } else if (object is GalleryFilterOneOfAny) {
      return object.toJson();
    } else if (object is GalleryFilterOneOfMultiple) {
      return object.toJson();
    } else if (object is GalleryFilterSwitcher) {
      return object.toJson();
    } else if (object is GalleryFilterRange) {
      return object.toJson();
    }
    return {};
  }
}

class GalleryFiltersJsonConverter
    extends JsonConverter<List<GalleryFilter>, List<dynamic>> {
  const GalleryFiltersJsonConverter();

  @override
  List<GalleryFilter> fromJson(List<dynamic> json) {
    final GalleryFilterJsonConverter converter = GalleryFilterJsonConverter();
    final knownTypes = GalleryFilterModes.values.toSet();

    return json
        .where((e) => e is Map && knownTypes.contains(e["type"]))
        .map((e) => converter.fromJson(e))
        .toList();
  }

  @override
  List<Map<String, dynamic>> toJson(List<GalleryFilter> object) {
    final GalleryFilterJsonConverter converter = GalleryFilterJsonConverter();
    return object.map((e) {
      return converter.toJson(e);
    }).toList();
  }
}

const GalleryFilterModes = {
  GalleryFilterType.MULTIPLE_OF_ANY: 'MULTIPLE_OF_ANY',
  GalleryFilterType.MULTIPLE_OF_MULTIPLE: 'MULTIPLE_OF_MULTIPLE',
  GalleryFilterType.ONE_OF_ANY: 'ONE_OF_ANY',
  GalleryFilterType.ONE_OF_MULTIPLE: 'ONE_OF_MULTIPLE',
  GalleryFilterType.SWITCHER: 'SWITCHER',
  GalleryFilterType.RANGE: 'RANGE',
};
