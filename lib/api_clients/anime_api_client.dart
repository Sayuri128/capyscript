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
  static const getGalleryFunctionName = 'getGallery';
  static const getGalleryPageParameterName = 'page';
  static const getGalleryQueryParameterName = 'query';
  static const getGalleryFiltersParameterName = 'filters';

  static const getConcreteFunctionName = 'getConcrete';
  static const getConcreteUidParameterName = 'uid';
  static const getConcreteDataParameterName = 'data';

  static const getVideoSourcesFunctionName = 'getVideoSources';
  static const getVideoSourcesUidParameterName = 'uid';
  static const getVideoSourcesSrcParameterName = 'src';
  static const getVideoSourcesDataParameterName = 'data';

  AnimeApiClient({required super.code});

  Future<List<AnimeGalleryView>> getGallery(
      {required int page, String? query, List<FilterData>? filters}) async {
    return ((await interpreter.runFunction(getGalleryFunctionName, arguments: {
      getGalleryPageParameterName: page,
      getGalleryQueryParameterName: query ?? '',
      getGalleryFiltersParameterName:
          filters?.map((e) => e.toJson()).toList() ?? []
    })) as List)
        .map((e) => AnimeGalleryView.fromJson(jsonDecode(jsonEncode(e))))
        .toList();
  }

  Future<AnimeConcreteView> getConcrete(
      {required String uid, required Map<String, dynamic> data}) async {
    return await interpreter.runFunction(getConcreteFunctionName, arguments: {
      getConcreteUidParameterName: uid,
      getConcreteDataParameterName: data
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
