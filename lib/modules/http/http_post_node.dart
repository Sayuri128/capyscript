import 'package:capyscript/AST/boolean/ast_boolean_node.dart';
import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/AST/map/ast_map_node.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/http/http_browser_response.dart';
import 'package:capyscript/modules/http/http_interceptor_controller.dart';
import 'package:capyscript/modules/http/http_response.dart';
import 'package:capyscript/modules/http/http_utils.dart';
import 'package:capyscript/modules/http/policy/http_request_policy_enforcer.dart';
import 'package:logger/logger.dart';

class HttpPostNode extends ModuleFunctionBody {
  final HttpInterceptorController? Function() getInterceptorController;
  final Map<String, String> Function() getHeaders;
  final HttpRequestPolicyEnforcer policyEnforcer;

  final Logger _logger = Logger();

  HttpPostNode(
      {required this.getInterceptorController,
      required this.getHeaders,
      required this.policyEnforcer});

  @override
  Future execute(InterpreterEnvironment environment) async {
    String url = getVariable("url", environment);
    final params = (getVariable("params", environment) as Map)
        .map((key, value) => MapEntry(key.toString(), value));
    final paths = (getVariable("paths", environment) as Map)
        .map((key, value) => MapEntry(key.toString(), value));
    final body = getVariable("body", environment);
    final scriptHeaders = (getVariable("headers", environment, defaultValue: {})
            as Map)
        .map((key, value) => MapEntry(key.toString(), value.toString()));
    final headers = policyEnforcer.composeHeaders(
        sessionHeaders: getHeaders(), callHeaders: scriptHeaders);
    final throughWeb = getVariable("throughWeb", environment);

    url = await HttpUtils.buildUri(url, params: params, paths: paths);
    Uri.parse(url);

    final controller = getInterceptorController();
    if (throughWeb && controller != null) {
      final webUrl = await policyEnforcer.resolveWebUrl(url);
      await policyEnforcer.acquireSlot();
      _logger.d(
          "httpPost: $webUrl through web browser interceptor controller\nheaders: $headers");
      final response = await controller.loadPage(
          url: webUrl, method: "POST", headers: headers, body: body);
      return CapyHttpBrowserResponse(
          cookies: response.cookies,
          statusCode: response.statusCode,
          body: response.body,
          contentLength: response.body.length,
          headers: response.headers);
    } else {
      final response = await policyEnforcer.send(url,
          (Uri attemptUri, Duration firstResponseTimeout) {
        _logger.d("httpPost: $attemptUri\nheaders: $headers");
        return HttpUtils.sendRequest("POST", attemptUri,
            headers: headers,
            body: body,
            firstResponseTimeout: firstResponseTimeout);
      });

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
        functionName: "httpPost",
        parameters: [
          ASTParameterNode("url", paramType: "string"),
          ASTParameterNode(
            "params",
            paramType: "Map",
            isOptional: true,
            defaultValue: ASTMapNode(
              keys: [],
              values: [],
            ),
          ),
          ASTParameterNode(
            "paths",
            paramType: "Map",
            isOptional: true,
            defaultValue: ASTMapNode(
              keys: [],
              values: [],
            ),
          ),
          ASTParameterNode(
            "body",
            paramType: "any",
            isOptional: true,
            defaultValue: ASTMapNode(
              keys: [],
              values: [],
            ),
          ),
          ASTParameterNode(
            "headers",
            paramType: "Map",
            isOptional: true,
            defaultValue: ASTMapNode(
              keys: [],
              values: [],
            ),
          ),
          ASTParameterNode(
            "throughWeb",
            paramType: "bool",
            isOptional: true,
            defaultValue: ASTBooleanNode(
              value: false,
            ),
          ),
        ],
        returnType: "any",
        body: this);
  }
}
/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */
