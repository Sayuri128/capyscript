/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/ast_tree.dart';
import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/html/create_html_parser_node.dart';

class HtmlModule extends BaseModule {
  static const String module_name = "html";

  HtmlModule() : super(moduleName: module_name) {
    final List<ASTFunctionDeclarationNode> functions = [];

    functions.add(CreateHtmlParserNode().toDeclarationNode());

    body = ASTTree(functions: functions, modules: []);
  }
}
