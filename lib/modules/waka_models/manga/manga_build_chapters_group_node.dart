/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'dart:convert';

import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_concrete_view/chapter/chapter.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_concrete_view/chapters_group/chapters_group.dart';

class MangaBuildChaptersGroupNode extends ModuleFunctionBody {
  @override
  Future<dynamic> execute(InterpreterEnvironment environment) async {
    final title = getVariable("title", environment);
    final elements = getVariable("elements", environment);
    final data = (getVariable("data", environment) as Map)
        .map((key, value) => MapEntry(key.toString(), value));
    return ChaptersGroup(
        title: title,
        elements: (elements as List<dynamic>)
            .map((e) => Chapter.fromJson(jsonDecode(jsonEncode(e))))
            .toList(),
        data: data);
  }

  @override
  ASTFunctionDeclarationNode toDeclarationNode() {
    return ASTFunctionDeclarationNode(
        functionName: "buildChapterGroups",
        parameters: [
          ASTParameterNode("title"),
          ASTParameterNode("elements"),
          ASTParameterNode("data"),
        ],
        body: this);
  }
}
