import 'package:capyscript/modules/waka_models/models/config_info/gallery_pagination/gallery_pagination.dart';
import 'package:capyscript/modules/waka_models/models/config_info/preferences/extension_preference.dart';
import 'package:capyscript/modules/waka_models/models/config_info/request_policy/request_policy.dart';

abstract class ExtensionPreferencesProvider {
  const ExtensionPreferencesProvider();

  Future<Object?> getPreference(String key);
}

class NoopExtensionPreferencesProvider extends ExtensionPreferencesProvider {
  const NoopExtensionPreferencesProvider();

  @override
  Future<Object?> getPreference(String key) async => null;
}

abstract class ExtensionStorage {
  const ExtensionStorage();

  Future<String?> read(String key);

  Future<void> write(String key, String value, {Duration? ttl});

  Future<void> remove(String key);
}

class NoopExtensionStorage extends ExtensionStorage {
  const NoopExtensionStorage();

  @override
  Future<String?> read(String key) async => null;

  @override
  Future<void> write(String key, String value, {Duration? ttl}) async {}

  @override
  Future<void> remove(String key) async {}
}

class ExtensionHost {
  final String? extensionUid;
  final List<ExtensionPreference> preferenceDefinitions;
  final ExtensionPreferencesProvider preferences;
  final ExtensionStorage storage;
  final RequestPolicy? requestPolicy;
  final GalleryPagination? pagination;

  const ExtensionHost({
    this.extensionUid,
    this.preferenceDefinitions = const <ExtensionPreference>[],
    this.preferences = const NoopExtensionPreferencesProvider(),
    this.storage = const NoopExtensionStorage(),
    this.requestPolicy,
    this.pagination,
  });

  static const ExtensionHost none = ExtensionHost();

  ExtensionPreference? preferenceDefinition(String key) {
    for (final ExtensionPreference definition in preferenceDefinitions) {
      if (definition.key == key) {
        return definition;
      }
    }
    return null;
  }

  Future<int> resolvePageSize() async {
    final GalleryPagination? declared = pagination;
    if (declared == null) {
      return 0;
    }
    Object? selected;
    try {
      selected =
          await preferences.getPreference(ExtensionPreference.pageSizeKey);
    } catch (_) {
      selected = null;
    }
    return declared.resolve(selected);
  }

  Future<Object?> resolvePreference(String key) async {
    final Object? stored = await preferences.getPreference(key);
    if (stored != null) {
      return stored;
    }
    return preferenceDefinition(key)?.effectiveDefault;
  }
}
