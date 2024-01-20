/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/ast_tree.dart';
import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/date/create_formatter_node.dart';
import 'package:capyscript/modules/date/parse_date_node.dart';

class DateModule extends BaseModule {
  static const String module_name = "date";

  DateModule() : super(moduleName: module_name) {
    final List<ASTFunctionDeclarationNode> functions = [];

    functions.add(CreateDateFormatterNode().toDeclarationNode());
    functions.add(ParseDateNode().toDeclarationNode());

    body = ASTTree(functions: functions, modules: []);
  }
}
