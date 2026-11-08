import 'dart:convert';

import 'package:capyscript/api_clients/api_client.dart';
import 'package:capyscript/modules/waka_models/audio/audio_source_reader.dart';
import 'package:capyscript/modules/waka_models/models/audio/audio_track_source.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_concrete_view/manga_concrete_view.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_gallery_view/filters/data/filters/filter_data.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_gallery_view/manga_gallery_view.dart';

class AudioApiClient extends ApiClient {
  static const getAudioSourcesFunctionName = 'getAudioSources';
  static const getAudioSourcesUidParameterName = 'uid';
  static const getAudioSourcesDataParameterName = 'data';

  AudioApiClient({required super.code, super.host});

  @override
  Future<List<MangaGalleryView>> getGallery(
      {required int page,
      String? query,
      List<FilterData>? filters,
      String? feed,
      int? pageSize}) async {
    return (await interpreter.runFunction(ApiClient.getGalleryFunctionName,
            arguments: await galleryArguments(
                page: page,
                query: query,
                filters: filters,
                feed: feed,
                pageSize: pageSize)) as List<dynamic>)
        .map((e) => MangaGalleryView.fromJson(jsonDecode(jsonEncode(e))))
        .toList();
  }

  @override
  Future<MangaConcreteView> getConcrete(
      {required String uid, required Map<String, dynamic> data}) async {
    final Object? result = await interpreter.runFunction(
        ApiClient.getConcreteFunctionName,
        arguments: {
          ApiClient.getConcreteUidParameterName: uid,
          ApiClient.getConcreteDataParameterName: data
        });
    if (result is MangaConcreteView) {
      return result;
    }
    return MangaConcreteView.fromJson(jsonDecode(jsonEncode(result)));
  }

  @override
  Future<List<MangaGalleryView>> getRelated(
      {required String uid, required Map<String, dynamic> data}) async {
    return (await runRelated(uid: uid, data: data))
        .map((e) => MangaGalleryView.fromJson(jsonDecode(jsonEncode(e))))
        .toList();
  }

  Future<List<AudioTrackSource>> getAudioSources(
      {required String uid, required Map<String, dynamic> data}) async {
    final Object? result =
        await interpreter.runFunction(getAudioSourcesFunctionName, arguments: {
      getAudioSourcesUidParameterName: uid,
      getAudioSourcesDataParameterName: data,
    });
    return AudioSourceReader.readSources(result);
  }
}
