import 'package:capyscript/AST/ast_tree.dart';
import 'package:capyscript/modules/http/http_execute_js_script_node.dart';
import 'package:capyscript/modules/http/http_get_headers_node.dart';
import 'package:capyscript/modules/http/http_get_node.dart';
import 'package:capyscript/modules/http/http_interceptor_controller.dart';
import 'package:capyscript/modules/http/http_post_node.dart';
import 'package:capyscript/modules/http/http_register_interceptor_controller_node.dart';
import 'package:capyscript/modules/http/http_use_headers_node.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/modules/abstract/base_module.dart';

part 'http_module.g.dart';

@JsonSerializable(explicitToJson: true)
class HttpModule extends BaseModule {
  static const String module_name = "http";

  HttpInterceptorController? _webBrowserInterceptorController;
  final Map<String, String> _headers = {};

  Map<String, String> getHeaders() {
    return Map.of(_headers);
  }

  void setHeaders(Map<String, String> headers) {
    _headers.clear();
    _headers.addAll(headers);
  }

  factory HttpModule.fromJson(Map<String, dynamic> json) =>
      _$HttpModuleFromJson(json);

  Map<String, dynamic> toJson() => _$HttpModuleToJson(this);

  HttpModule() : super(moduleName: module_name) {
    final List<ASTFunctionDeclarationNode> functions = [];

    functions.add(HttpGetNode(
            getInterceptorController: () => _webBrowserInterceptorController,
            getHeaders: getHeaders)
        .toDeclarationNode());
    functions.add(HttpPostNode(
            getInterceptorController: () => _webBrowserInterceptorController,
            getHeaders: getHeaders)
        .toDeclarationNode());
    functions.add(HttpRegisterInterceptorControllerNode(
        registerInterceptorController: (controller) =>
            _webBrowserInterceptorController = controller).toDeclarationNode());
    functions.add(HttpExecuteJsScriptNode(
            getInterceptorController: () => _webBrowserInterceptorController)
        .toDeclarationNode());
    functions.add(
        HttpUserHeadersNode(getHttpModule: () => this).toDeclarationNode());
    functions
        .add(HttpGetHeadersNode(getHeaders: getHeaders).toDeclarationNode());

    body = ASTTree(functions: functions, modules: []);
  }
}
