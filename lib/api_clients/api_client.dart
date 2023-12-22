/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/Interpreter/interpreter.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/http/http_interceptor_controller.dart';
import 'package:capyscript/modules/http/http_module.dart';

abstract class ApiClient {
  static const passProtectorFunctionMame = 'passProtector';
  static const passProtectorHeadersParameterName = 'data';

  static const passWebBrowserInterceptorControllerFunctionName =
      'passWebBrowserInterceptorController';
  static const passWebBrowserInterceptorControllerParameterName = 'controller';

  late final Interpreter interpreter;

  ApiClient({required String code}) {
    interpreter = Interpreter(data: code);
  }

  Future<void> passProtector({required Map<String, dynamic> data}) async {
    return await interpreter.runFunction(passProtectorFunctionMame,
        arguments: data);
  }

  Future<void> passWebBrowserInterceptorController(
      {required HttpInterceptorController controller}) async {
    return await interpreter.runFunction(
        passWebBrowserInterceptorControllerFunctionName,
        arguments: {passWebBrowserInterceptorControllerParameterName: controller});
  }

  Map<String, String> getProtectorHeaders() {
    return (modules[HttpModule.module_name] as HttpModule).getHeaders();
  }
}
