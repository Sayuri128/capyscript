/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/Interpreter/interpreter.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/http/http_interceptor_controller.dart';
import 'package:capyscript/modules/http/http_module.dart';

abstract class ApiClient {
  late final Interpreter interpreter;

  ApiClient({required String code}) {
    interpreter = Interpreter(data: code);
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
    return (modules[HttpModule.module_name] as HttpModule).getHeaders();
  }

  Future<Map<String, String>> getImageHeaders(
      {required String uid, required Map<String, dynamic> data}) async {
    return ((await interpreter.runFunction("getImageHeaders",
            arguments: {"uid": uid, "data": data})) as Map)
        .map((key, value) => MapEntry(key.toString(), value.toString()));
  }
}
