/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'dart:convert';

import 'package:capyscript/api_clients/api_client.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_concrete_view/chapter/chapter.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_concrete_view/chapter/pages/pages.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_concrete_view/manga_concrete_view.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_gallery_view/filters/data/filters/filter_data.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_gallery_view/manga_gallery_view.dart';

class MangaApiClient extends ApiClient {
  static const getGalleryFunctionName = 'getGallery';
  static const getGalleryPageParameterName = 'page';
  static const getGalleryQueryParameterName = 'query';
  static const getGalleryFiltersParameterName = 'filters';

  static const getConcreteFunctionName = 'getConcrete';
  static const getConcreteUidParameterName = 'uid';
  static const getConcreteDataParameterName = 'data';

  static const getChaptersFunctionName = 'getChapters';
  static const getChaptersUidParameterName = 'uid';

  static const getPagesFunctionName = 'getPages';
  static const getPagesUidParameterName = 'uid';
  static const getPagesDataParameterName = 'data';

  MangaApiClient({required super.code});

  Future<List<MangaGalleryView>> getGallery(
      {required int page, String? query, List<FilterData>? filters}) async {
    return (await interpreter.runFunction(getGalleryFunctionName, arguments: {
      getGalleryPageParameterName: page,
      getGalleryQueryParameterName: query ?? '',
      getGalleryFiltersParameterName:
          filters?.map((e) => e.toJson()).toList() ?? []
    }) as List<dynamic>)
        .map((e) => MangaGalleryView.fromJson(jsonDecode(jsonEncode(e))))
        .toList();
  }

  Future<MangaConcreteView> getConcrete(
      {required String uid, required Map<String, dynamic> data}) async {
    return (await interpreter.runFunction(getConcreteFunctionName, arguments: {
      getConcreteUidParameterName: uid,
      getConcreteDataParameterName: data
    }));
  }

  Future<List<Chapter>> getChapters({required String uid}) async {
    return (await interpreter.runFunction(getChaptersFunctionName,
            arguments: {getChaptersUidParameterName: uid}) as List<dynamic>)
        .map((e) => Chapter.fromJson(jsonDecode(jsonEncode(e))))
        .toList();
  }

  Future<Pages> getPages(
      {required String uid, required Map<String, dynamic>? data}) async {
    return (await interpreter.runFunction(getPagesFunctionName, arguments: {
      getPagesUidParameterName: uid,
      getPagesDataParameterName: data
    }));
  }
}
