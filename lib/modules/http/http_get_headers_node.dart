/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:capyscript/modules/abstract/base_module.dart';

class HttpGetHeadersNode extends ModuleFunctionBody {
  final Map<String, String> Function() getHeaders;

  HttpGetHeadersNode({required this.getHeaders});

  @override
  Future<dynamic> execute(InterpreterEnvironment environment) async {
    return getHeaders();
  }

  @override
  ASTFunctionDeclarationNode toDeclarationNode() {
    return ASTFunctionDeclarationNode(
        functionName: "getHeaders", parameters: [], body: this);
  }
}
