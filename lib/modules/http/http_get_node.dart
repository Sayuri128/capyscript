import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/http/http_browser_response.dart';
import 'package:capyscript/modules/http/http_interceptor_controller.dart';
import 'package:capyscript/modules/http/http_response.dart';
import 'package:capyscript/modules/http/http_utils.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

class HttpGetNode extends ModuleFunctionBody {
  final HttpInterceptorController? Function() getInterceptorController;
  final Map<String, String> Function() getHeaders;

  final Logger _logger = Logger();

  HttpGetNode(
      {required this.getInterceptorController, required this.getHeaders});

  @override
  Future<dynamic> execute(InterpreterEnvironment environment) async {
    String url = getVariable("url", environment);
    final params = (getVariable("params", environment) as Map)
        .map((key, value) => MapEntry(key.toString(), value));
    final paths = (getVariable("paths", environment) as Map).map((key, value) =>
        MapEntry(key.toString(), value));
    final headers = (getVariable("headers", environment, defaultValue: {})
    as Map)
        .map((key, value) => MapEntry(key.toString(), value.toString()))
      ..addAll(getHeaders());
    final throughWeb = getVariable("throughWeb", environment);

    url = await HttpUtils.buildUri(url, params: params, paths: paths);
    final uri = Uri.parse(url);

    final controller = getInterceptorController();
    if (throughWeb && controller != null) {
      _logger.d(
          "httpGet: $url through web browser interceptor controller\nheaders: $headers");
      final response =
      await controller.loadPage(url: url, method: "GET", headers: headers);
      return CapyHttpBrowserResponse(
          cookies: response.cookies,
          statusCode: response.statusCode,
          body: response.body,
          contentLength: response.body.length,
          headers: response.headers);
    } else {
      _logger.d("httpGet: $url\nheaders: $headers");
      final response = await http.get(uri, headers: headers);

      return CapyHttpResponse(
          statusCode: response.statusCode,
          body: response.body,
          headers: response.headers,
          contentLength: response.contentLength);
    }
  }

  @override
  ASTFunctionDeclarationNode toDeclarationNode() {
    return ASTFunctionDeclarationNode(
        functionName: "httpGet",
        parameters: [
          ASTParameterNode("url"),
          ASTParameterNode("params"),
          ASTParameterNode("paths"),
          ASTParameterNode("headers"),
          ASTParameterNode("throughWeb"),
        ],
        body: this);
  }
}
