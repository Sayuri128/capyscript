/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/ast_tree.dart';
import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/modules/abstract/base_module.dart';

class DateModule extends BaseModule {
  DateModule() : super(moduleName: "date") {
    final List<ASTFunctionDeclarationNode> functions = [];


    body = ASTTree(functions: functions, modules: []);
  }
}
