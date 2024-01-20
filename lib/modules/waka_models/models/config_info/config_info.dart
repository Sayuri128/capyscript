import 'package:capyscript/modules/abstract/external_object.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_gallery_view/filters/gallery_filter.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_gallery_view/filters/multiple_of_multiple/multiple_of_multiple.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_gallery_view/filters/one_of_any/one_of_any.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_gallery_view/filters/one_of_multiple/one_of_multiple.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_gallery_view/filters/switcher/swircher.dart';
import 'package:json_annotation/json_annotation.dart';

import '../manga/manga_gallery_view/filters/multiple_of_any/multiple_of_any.dart';
import 'protector_config/protector_config.dart';

part 'config_info.g.dart';

enum ConfigInfoType {
  @JsonValue(0)
  MANGA,
  @JsonValue(1)
  ANIME
}

int serializeLocalApiClientType(ConfigInfoType type) {
  switch (type) {
    case ConfigInfoType.MANGA:
      return 0;
    case ConfigInfoType.ANIME:
      return 1;
  }
}

ConfigInfoType deserializeLocalApiClientType(int type) {
  switch (type) {
    case 0:
      return ConfigInfoType.MANGA;
    case 1:
      return ConfigInfoType.ANIME;
  }
  throw Exception("Unknown LocalApiClientType $type");
}

@JsonSerializable()
class ConfigInfo extends ExternalObject {
  factory ConfigInfo.fromJson(Map<String, dynamic> json) =>
      _$ConfigInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigInfoToJson(this);

  final String uid;
  final String name;
  final String logoUrl;
  final ConfigInfoType type;
  final bool nsfw;
  final String language;
  final int version;

  @GalleryFiltersJsonConverter()
  final List<GalleryFilter> filters;

  @ProtectorConfigJsonConverter()
  final ProtectorConfig? protectorConfig;

  final bool searchAvailable;

  @override
  getField(String name) {
    if (name == 'name') {
      return name;
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
    } else if (name == 'searchAvailable') {
      return searchAvailable;
    } else if (name == 'uid') {
      return uid;
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
      required this.searchAvailable});

  @override
  callFunction(String name, {List? ordinalArguments}) {}
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

    return json.map((e) {
      return converter.fromJson(e);
    }).toList();
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
};
