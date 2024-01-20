/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/http/http_interceptor_controller.dart';

class HttpExecuteJsScriptNode extends ModuleFunctionBody {
  final HttpInterceptorController? Function() getInterceptorController;

  HttpExecuteJsScriptNode({required this.getInterceptorController});

  @override
  Future<dynamic> execute(InterpreterEnvironment environment) async {
    final controller = getInterceptorController();
    if (controller == null) {
      throw Exception("HttpInterceptorController is not registered");
    }
    return await controller
        .executeJsScript((await environment.getVariable("code")) as String);
  }

  @override
  ASTFunctionDeclarationNode toDeclarationNode() {
    return ASTFunctionDeclarationNode(
        functionName: "executeJsScript",
        parameters: [ASTParameterNode("code")],
        body: this);
  }
}
