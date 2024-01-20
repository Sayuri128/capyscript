/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:capyscript/modules/abstract/base_module.dart';

class ParseIntNode extends ModuleFunctionBody {
  @override
  Future execute(InterpreterEnvironment environment) async {
    final value = getVariable("value", environment);
    return int.parse(value.toString());
  }

  @override
  ASTFunctionDeclarationNode toDeclarationNode() {
    return ASTFunctionDeclarationNode(
        functionName: "parseInt",
        parameters: [ASTParameterNode("value")],
        body: this);
  }
}
