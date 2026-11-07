import 'dart:convert';

import 'package:capyscript/api_clients/api_client.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_concrete_view/manga_concrete_view.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_gallery_view/filters/data/filters/filter_data.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_gallery_view/manga_gallery_view.dart';
import 'package:capyscript/modules/waka_models/models/novel/novel_chapter_content.dart';

class NovelApiClient extends ApiClient {
  static const getChapterTextFunctionName = 'getChapterText';
  static const getChapterTextUidParameterName = 'uid';
  static const getChapterTextDataParameterName = 'data';
  static const getImageHeadersFunctionName = 'getImageHeaders';

  NovelApiClient({required super.code, super.host});

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

  @override
  Future<Map<String, String>> getImageHeaders(
      {required String uid, required Map<String, dynamic> data}) async {
    if (!interpreter.hasFunction(getImageHeadersFunctionName)) {
      return const <String, String>{};
    }
    return super.getImageHeaders(uid: uid, data: data);
  }

  Future<NovelChapterContent> getChapterText(
      {required String uid, required Map<String, dynamic> data}) async {
    final Object? result =
        await interpreter.runFunction(getChapterTextFunctionName, arguments: {
      getChapterTextUidParameterName: uid,
      getChapterTextDataParameterName: data,
    });
    return readChapterContent(result);
  }

  static NovelChapterContent readChapterContent(Object? result) {
    if (result is NovelChapterContent) {
      return result;
    }
    if (result is String) {
      return NovelChapterContent(html: result);
    }
    if (result is Map) {
      return NovelChapterContent.fromJson(
          result.map((key, value) => MapEntry(key.toString(), value)));
    }
    throw FormatException(
        'getChapterText must return buildNovelChapter(...) or a string, got ${result.runtimeType}');
  }
}
