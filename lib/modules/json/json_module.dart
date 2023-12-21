/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/ast_tree.dart';
import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/json/json_deserialize_node.dart';
import 'package:capyscript/modules/json/json_serialize_node.dart';

class JsonModule extends BaseModule {
  static const String module_name = "json";

  JsonModule() : super(moduleName: module_name) {
    final List<ASTFunctionDeclarationNode> functions = [];

    functions.add(JsonSerializeNode().toDeclarationNode());
    functions.add(JsonDeserializeNode().toDeclarationNode());

    body = ASTTree(functions: functions, modules: []);
  }
}
