import 'package:capyscript/AST/ast_tree.dart';
import 'package:capyscript/api_clients/host/extension_host.dart';
import 'package:capyscript/modules/http/http_current_mirror_node.dart';
import 'package:capyscript/modules/http/http_execute_js_script_node.dart';
import 'package:capyscript/modules/http/http_get_headers_node.dart';
import 'package:capyscript/modules/http/http_get_node.dart';
import 'package:capyscript/modules/http/http_interceptor_controller.dart';
import 'package:capyscript/modules/http/http_post_node.dart';
import 'package:capyscript/modules/http/http_register_interceptor_controller_node.dart';
import 'package:capyscript/modules/http/http_use_headers_node.dart';
import 'package:capyscript/modules/http/policy/http_request_policy_enforcer.dart';
import 'package:capyscript/modules/http/policy/http_request_state.dart';
import 'package:capyscript/modules/http/http_utils.dart';
import 'package:http/http.dart' as http;
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

  @JsonKey(includeFromJson: false, includeToJson: false)
  final ExtensionHost host;

  late final HttpRequestPolicyEnforcer _policyEnforcer;
  HttpInterceptorController? _webBrowserInterceptorController;
  final Map<String, String> _headers = {};

  Map<String, String> getHeaders() {
    return Map.of(_headers);
  }

  Future<http.Response> send(String method, String url,
      {Map<String, String> headers = const {}, Object? body}) {
    final Map<String, String> composed = _policyEnforcer.composeHeaders(
        sessionHeaders: getHeaders(), callHeaders: headers);
    return _policyEnforcer.send(url,
        (Uri attemptUri, Duration firstResponseTimeout) {
      return HttpUtils.sendRequest(method, attemptUri,
          headers: composed,
          body: body,
          firstResponseTimeout: firstResponseTimeout);
    });
  }

  void setHeaders(Map<String, String> headers) {
    _headers.clear();
    _headers.addAll(headers);
  }

  factory HttpModule.fromJson(Map<String, dynamic> json) =>
      _$HttpModuleFromJson(json);

  Map<String, dynamic> toJson() => _$HttpModuleToJson(this);

  HttpModule({this.host = ExtensionHost.none})
      : super(moduleName: module_name) {
    _policyEnforcer = HttpRequestPolicyEnforcer(
        host: host, state: HttpRequestStateRegistry.stateFor(host.extensionUid));
    final List<ASTFunctionDeclarationNode> functions = [];

    functions.add(HttpGetNode(
            getInterceptorController: () => _webBrowserInterceptorController,
            getHeaders: getHeaders,
            policyEnforcer: _policyEnforcer)
        .toDeclarationNode());
    functions.add(HttpPostNode(
            getInterceptorController: () => _webBrowserInterceptorController,
            getHeaders: getHeaders,
            policyEnforcer: _policyEnforcer)
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
    functions.add(HttpCurrentMirrorNode(policyEnforcer: _policyEnforcer)
        .toDeclarationNode());

    body = ASTTree(functions: functions, modules: []);
  }
}
