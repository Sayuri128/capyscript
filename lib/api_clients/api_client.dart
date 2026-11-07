/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/Interpreter/interpreter.dart';
import 'package:capyscript/api_clients/host/extension_host.dart';
import 'package:capyscript/modules/http/http_interceptor_controller.dart';
import 'package:capyscript/modules/http/http_module.dart';
import 'package:capyscript/modules/waka_models/models/common/concrete_view.dart';
import 'package:capyscript/modules/waka_models/models/common/gallery_view.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_gallery_view/filters/data/filters/filter_data.dart';

abstract class ApiClient {
  static const getGalleryFunctionName = 'getGallery';
  static const getGalleryPageParameterName = 'page';
  static const getGalleryQueryParameterName = 'query';
  static const getGalleryFiltersParameterName = 'filters';
  static const getGalleryFeedParameterName = 'feed';

  static const getConcreteFunctionName = 'getConcrete';
  static const getConcreteUidParameterName = 'uid';
  static const getConcreteDataParameterName = 'data';

  late final Interpreter interpreter;
  final ExtensionHost host;

  ApiClient({required String code, this.host = ExtensionHost.none}) {
    interpreter = Interpreter(data: code, host: host);
  }

  Future<List<GalleryView>> getGallery(
      {required int page,
      String? query,
      List<FilterData>? filters,
      String? feed});

  Future<ConcreteView> getConcrete(
      {required String uid, required Map<String, dynamic> data});

  Map<String, dynamic> galleryArguments(
      {required int page,
      String? query,
      List<FilterData>? filters,
      String? feed}) {
    return {
      getGalleryPageParameterName: page,
      getGalleryQueryParameterName: query ?? '',
      getGalleryFiltersParameterName:
          filters?.map((e) => e.toJson()).toList() ?? [],
      getGalleryFeedParameterName: feed ?? '',
    };
  }

  Future<void> passProtector(
      {required String body,
      required Map<String, String> headers,
      required Map<String, String> cookies}) async {
    return await interpreter.runFunction('passProtector',
        arguments: {"body": body, "headers": headers, "cookies": cookies});
  }

  Future<void> passWebBrowserInterceptorController(
      {required HttpInterceptorController controller}) async {
    return await interpreter.runFunction("passWebBrowserInterceptorController",
        arguments: {"controller": controller});
  }

  Map<String, String> getProtectorHeaders() {
    final module = interpreter.builtinModule(HttpModule.module_name);
    return module is HttpModule ? module.getHeaders() : <String, String>{};
  }

  Future<Map<String, String>> getImageHeaders(
      {required String uid, required Map<String, dynamic> data}) async {
    return ((await interpreter.runFunction("getImageHeaders",
            arguments: {"uid": uid, "data": data})) as Map)
        .map((key, value) => MapEntry(key.toString(), value.toString()));
  }
}
