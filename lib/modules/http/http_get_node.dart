import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/http/http_browser_response.dart';
import 'package:capyscript/modules/http/http_interceptor_controller.dart';
import 'package:capyscript/modules/http/http_response.dart';
import 'package:http/http.dart' as http;

/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

class HttpGetNode extends ModuleFunctionBody {
  final HttpInterceptorController? Function() getInterceptorController;

  HttpGetNode({required this.getInterceptorController});

  @override
  Future<dynamic> execute(InterpreterEnvironment environment) async {
    final url = getVariable("url", environment);
    final params = getVariable("params", environment);
    final paths = getVariable("paths", environment);
    final headers = (getVariable("headers", environment) as Map)
        .map((key, value) => MapEntry(key.toString(), value.toString()));
    final throughWeb = getVariable("throughWeb", environment);

    String uri = url;

    for (var element in (params as Map<dynamic, dynamic>).entries) {
      if (element.value is List) {
        uri = '$uri${uri.endsWith('?') ? '' : '&'}${element.key}[]='
            '${(await Future.wait((element.value as List).map((e) async => e))).join(',')}';
      } else if (element.value is Map) {
        uri = '$uri${uri.endsWith('?') ? '' : '&'}'
            '${(await Future.wait((element.value as Map).entries.map((e) async => '${element.key}[${e.key}]=${e.value}'))).join('&')}';
      } else {
        uri =
            '$uri${uri.endsWith('?') ? '' : '&'}${element.key}=${element.value}';
      }
    }

    for (var element in (paths as Map<dynamic, dynamic>).entries) {
      uri = uri.replaceFirst(element.key, element.value);
    }

    final controller = getInterceptorController();
    if (throughWeb && controller != null) {
      final response =
          await controller.loadPage(url: uri, method: "GET", headers: headers);
      return CapyHttpBrowserResponse(
          cookies: response.cookies,
          statusCode: response.statusCode,
          body: response.body,
          contentLength: response.body.length,
          headers: headers);
    } else {
      final response = await http.get(Uri.parse(uri), headers: headers);

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
