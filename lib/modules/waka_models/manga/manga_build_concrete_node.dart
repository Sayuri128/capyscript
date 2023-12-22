/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'dart:convert';

import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_concrete_view/chapters_group/chapters_group.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_concrete_view/manga_concrete_view.dart';

class MangaBuildConcreteNode extends ModuleFunctionBody {
  @override
  Future<dynamic> execute(InterpreterEnvironment environment) async {
    final uid = getVariable('uid', environment);
    final cover = getVariable('cover', environment);
    final title = getVariable('title', environment);
    final description = getVariable('description', environment);
    final tags = getVariable('tags', environment);
    final groups = getVariable('groups', environment);
    final status = getVariable('status', environment);
    final alternativeTitles = getVariable('alternativeTitles', environment);
    return MangaConcreteView(
        uid: uid,
        cover: cover,
        title: title,
        description: description,
        tags: (tags as List<dynamic>).map((e) => e.toString()).toList(),
        groups: (groups as List<dynamic>)
            .map((e) => ChaptersGroup.fromJson(jsonDecode(jsonEncode(e))))
            .toList(),
        status: status,
        alternativeTitles: (alternativeTitles as List<dynamic>)
            .map((e) => e.toString())
            .toList());
  }

  @override
  ASTFunctionDeclarationNode toDeclarationNode() {
    return ASTFunctionDeclarationNode(
        functionName: "buildConcrete",
        parameters: [
          ASTParameterNode("uid"),
          ASTParameterNode("cover"),
          ASTParameterNode("title"),
          ASTParameterNode("description"),
          ASTParameterNode("tags"),
          ASTParameterNode("groups"),
          ASTParameterNode("status"),
          ASTParameterNode("alternativeTitles")
        ],
        body: this);
  }
}
