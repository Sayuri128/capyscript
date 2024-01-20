/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/ast_tree.dart';
import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/converter/parse_double_node.dart';
import 'package:capyscript/modules/converter/parse_int_node.dart';
import 'package:capyscript/modules/converter/parse_string_node.dart';

class ConverterModule extends BaseModule {
  static const String module_name = "converter";

  ConverterModule() : super(moduleName: module_name) {
    final List<ASTFunctionDeclarationNode> functions = [];

    functions.add(ParseDoubleNode().toDeclarationNode());
    functions.add(ParseStringNode().toDeclarationNode());
    functions.add(ParseIntNode().toDeclarationNode());

    body = ASTTree(functions: functions, modules: []);
  }
}
