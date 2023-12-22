import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/http/http_interceptor_controller.dart';
import 'package:capyscript/modules/http/http_response.dart';
import 'package:http/http.dart' as http;

class HttpPostNode extends ModuleFunctionBody {
  final HttpInterceptorController? Function() getInterceptorController;
  final Map<String, String> Function() getHeaders;

  HttpPostNode(
      {required this.getInterceptorController, required this.getHeaders});

  @override
  Future execute(InterpreterEnvironment environment) async {
    final url = getVariable("url", environment);
    final body = getVariable("body", environment);
    final headers = (getVariable("headers", environment) as Map)
        .map((key, value) => MapEntry(key.toString(), value.toString()))
      ..addAll(getHeaders());

    final response =
        await http.post(Uri.parse(url), body: body, headers: headers);

    return CapyHttpResponse(
        statusCode: response.statusCode,
        body: response.body,
        headers: response.headers,
        contentLength: response.contentLength);
  }

  @override
  ASTFunctionDeclarationNode toDeclarationNode() {
    return ASTFunctionDeclarationNode(
        functionName: "httpPost",
        parameters: [
          ASTParameterNode("url"),
          ASTParameterNode("body"),
          ASTParameterNode("headers")
        ],
        body: this);
  }
}
/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */
