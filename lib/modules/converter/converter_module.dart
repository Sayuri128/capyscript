/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'dart:convert';

import 'package:capyscript/AST/ast_tree.dart';
import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/abstract/native_function_node.dart';
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

    for (final entry in <String, String Function(String)>{
      "base64Encode": (value) => base64.encode(utf8.encode(value)),
      "base64Decode": (value) =>
          utf8.decode(base64.decode(base64.normalize(value)), allowMalformed: true),
      "urlEncode": Uri.encodeComponent,
      "urlDecode": Uri.decodeComponent,
    }.entries) {
      functions.add(NativeFunctionNode(
        name: entry.key,
        returnType: "string",
        parameters: [ASTParameterNode("value", paramType: "any")],
        implementation: (arguments) => entry.value(arguments["value"].toString()),
      ).toDeclarationNode());
    }

    body = ASTTree(functions: functions, modules: []);
  }
}
