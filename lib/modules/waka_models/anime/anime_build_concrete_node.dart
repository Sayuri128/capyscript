/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'dart:convert';

import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/waka_models/models/anime/anime_concrete_view/anime_concrete_view.dart';
import 'package:capyscript/modules/waka_models/models/anime/anime_concrete_view/anime_video_group/anime_video_group.dart';

class AnimeBuildConcreteNode extends ModuleFunctionBody {
  @override
  Future<dynamic> execute(InterpreterEnvironment environment) async {
    final uid = getVariable("uid", environment);
    final cover = getVariable("cover", environment);
    final title = getVariable("title", environment);
    final description = getVariable("description", environment);
    final tags = (getVariable("tags", environment) as List).map((e) =>
        e.toString()).toList();
    final groups = getVariable("groups", environment);
    final alternativeTitles = ((getVariable(
        "alternativeTitles", environment, defaultValue: null) ?? []) as List)
        .map((e) => e.toString())
        .toList();
    final status = getVariable("status", environment);
    return AnimeConcreteView(
        uid: uid,
        cover: cover,
        title: title,
        alternativeTitles: alternativeTitles,
        description: description,
        tags: tags,
        groups: (groups as List<dynamic>)
            .map((e) => AnimeVideoGroup.fromJson(jsonDecode(jsonEncode(e))))
            .toList(),
        status: status);
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
          ASTParameterNode("alternativeTitles"),
          ASTParameterNode("status"),
        ],
        body: this);
  }
}
