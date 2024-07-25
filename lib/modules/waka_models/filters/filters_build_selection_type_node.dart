/*
 * Copyright (c) 2024 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/waka_models/models/filters/filter_selection_type.dart';

class FiltersBuildSelectionTypeNode extends ModuleFunctionBody {
  @override
  Future<FilterSelectionType?> execute(
      InterpreterEnvironment environment) async {
    final type = getVariable("type", environment);

    switch (type) {
      case "single":
        return FilterSelectionType.single;
      case "multiple":
        return FilterSelectionType.multiple;
      case 'sort':
        return FilterSelectionType.sort;
      default:
        return null;
    }
  }

  @override
  ASTFunctionDeclarationNode toDeclarationNode() {
    return ASTFunctionDeclarationNode(
      functionName: "buildSelectionType",
      parameters: [
        ASTParameterNode("type"),
      ],
      body: this,
    );
  }
}
