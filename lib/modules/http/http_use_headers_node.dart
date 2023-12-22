/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/http/http_module.dart';

class HttpUserHeadersNode extends ModuleFunctionBody {
  final HttpModule Function() getHttpModule;

  HttpUserHeadersNode({required this.getHttpModule});

  @override
  Future<dynamic> execute(InterpreterEnvironment environment) async {
    final headers = (await environment.getVariable("headers") as Map)
        .map((key, value) => MapEntry(key.toString(), value.toString()));
    getHttpModule().setHeaders(headers);
    return null;
  }

  @override
  ASTFunctionDeclarationNode toDeclarationNode() {
    return ASTFunctionDeclarationNode(
        functionName: "useHeaders",
        parameters: [ASTParameterNode("headers")],
        body: this);
  }
}
