/*
 * Copyright (c) 2024 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/waka_models/models/filters/filter_selection_option_model.dart';

class FiltersBuildSelectionOptionNode extends ModuleFunctionBody {
  @override
  Future<FilterSelectionOptionModel> execute(
      InterpreterEnvironment environment) async {
    final title = getVariable("title", environment);
    final value = getVariable("value", environment);

    return FilterSelectionOptionModel(
      title: title,
      value: value,
    );
  }

  @override
  ASTFunctionDeclarationNode toDeclarationNode() {
    return ASTFunctionDeclarationNode(
      functionName: "buildSelectionOption",
      parameters: [
        ASTParameterNode("title"),
        ASTParameterNode("value"),
      ],
      body: this,
    );
  }
}
