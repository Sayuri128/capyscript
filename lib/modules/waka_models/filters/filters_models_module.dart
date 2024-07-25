/*
 * Copyright (c) 2024 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/ast_tree.dart';
import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/waka_models/filters/filters_build_selection_node.dart';
import 'package:capyscript/modules/waka_models/filters/filters_build_selection_option_node.dart';
import 'package:capyscript/modules/waka_models/filters/filters_build_selection_type_node.dart';

class FiltersModelsModule extends BaseModule {
  static const String module_name = "filters_models";

  FiltersModelsModule() : super(moduleName: module_name) {
    final List<ASTFunctionDeclarationNode> functions = [];

    functions.add(FiltersBuildSelectionNode().toDeclarationNode());
    functions.add(FiltersBuildSelectionOptionNode().toDeclarationNode());
    functions.add(FiltersBuildSelectionTypeNode().toDeclarationNode());

    body = ASTTree(functions: functions, modules: []);
  }
}
