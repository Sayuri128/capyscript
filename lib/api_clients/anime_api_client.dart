/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'dart:convert';

import 'package:capyscript/api_clients/api_client.dart';
import 'package:capyscript/modules/waka_models/anime/anime_video_source_reader.dart';
import 'package:capyscript/modules/waka_models/models/anime/anime_concrete_view/anime_concrete_view.dart';
import 'package:capyscript/modules/waka_models/models/anime/anime_concrete_view/anime_video/anime_video.dart';
import 'package:capyscript/modules/waka_models/models/anime/anime_concrete_view/anime_video/anime_video_source.dart';
import 'package:capyscript/modules/waka_models/models/anime/anime_gallery_view/anime_gallery_view.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_gallery_view/filters/data/filters/filter_data.dart';

class AnimeApiClient extends ApiClient {
  static const getVideoSourcesFunctionName = 'getVideoSources';
  static const getVideoSourcesUidParameterName = 'uid';
  static const getVideoSourcesSrcParameterName = 'src';
  static const getVideoSourcesDataParameterName = 'data';

  AnimeApiClient({required super.code, super.host});

  @override
  Future<List<AnimeGalleryView>> getGallery(
      {required int page,
      String? query,
      List<FilterData>? filters,
      String? feed,
      int? pageSize}) async {
    return ((await interpreter.runFunction(ApiClient.getGalleryFunctionName,
            arguments: await galleryArguments(
                page: page,
                query: query,
                filters: filters,
                feed: feed,
                pageSize: pageSize)))
            as List)
        .map((e) => AnimeGalleryView.fromJson(jsonDecode(jsonEncode(e))))
        .toList();
  }

  @override
  Future<AnimeConcreteView> getConcrete(
      {required String uid, required Map<String, dynamic> data}) async {
    return await interpreter.runFunction(ApiClient.getConcreteFunctionName,
        arguments: {
          ApiClient.getConcreteUidParameterName: uid,
          ApiClient.getConcreteDataParameterName: data
        });
  }

  Future<bool> supportsVideoSources() async {
    return interpreter.hasFunction(getVideoSourcesFunctionName);
  }

  Future<List<AnimeVideoSource>> getVideoSources(AnimeVideo video) async {
    final result =
        await interpreter.runFunction(getVideoSourcesFunctionName, arguments: {
      getVideoSourcesUidParameterName: video.uid,
      getVideoSourcesSrcParameterName: video.src,
      getVideoSourcesDataParameterName: video.data,
    });
    return AnimeVideoSourceReader.readSources(result);
  }
}
