/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/http/http_interceptor_controller.dart';

class HttpRegisterInterceptorControllerNode extends ModuleFunctionBody {
  final void Function(HttpInterceptorController controller)
      registerInterceptorController;

  HttpRegisterInterceptorControllerNode(
      {required this.registerInterceptorController});

  @override
  Future<dynamic> execute(InterpreterEnvironment environment) async {
    final controller = getVariable("controller", environment);
    registerInterceptorController(controller);
    return controller;
  }

  @override
  ASTFunctionDeclarationNode toDeclarationNode() {
    return ASTFunctionDeclarationNode(
        functionName: "registerInterceptorController",
        parameters: [ASTParameterNode("controller")],
        body: this);
  }
}
