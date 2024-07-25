/*
 * Copyright (c) 2024 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/waka_models/models/filters/filter_selection_model.dart';
import 'package:capyscript/modules/waka_models/models/filters/filter_selection_option_model.dart';

class FiltersBuildSelectionNode extends ModuleFunctionBody {
  @override
  Future<FilterSelectionModel> execute(
      InterpreterEnvironment environment) async {
    final title = getVariable("title", environment);
    final options = (getVariable("options", environment) as List<dynamic>)
        .map((e) => e as FilterSelectionOptionModel)
        .toList();
    final mode = getVariable("mode", environment);

    return FilterSelectionModel(
      title: title,
      options: options,
      mode: mode,
    );
  }

  @override
  ASTFunctionDeclarationNode toDeclarationNode() {
    return ASTFunctionDeclarationNode(
      functionName: "buildSelection",
      parameters: [
        ASTParameterNode("title"),
        ASTParameterNode("options"),
        ASTParameterNode("mode"),
      ],
      body: this,
    );
  }
}
