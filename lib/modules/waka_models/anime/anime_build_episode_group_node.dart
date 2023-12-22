/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'dart:convert';

import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/waka_models/models/anime/anime_concrete_view/anime_video/anime_video.dart';
import 'package:capyscript/modules/waka_models/models/anime/anime_concrete_view/anime_video_group/anime_video_group.dart';

class AnimeBuildEpisodeGroupNode extends ModuleFunctionBody {
  @override
  Future<dynamic> execute(InterpreterEnvironment environment) async {
    final title = getVariable("title", environment);
    final videos = getVariable("videos", environment);
    final data = getVariable("data", environment);
    return AnimeVideoGroup(
        title: title,
        elements: (videos as List<dynamic>)
            .map((e) => AnimeVideo.fromJson(jsonDecode(jsonEncode(e))))
            .toList(),
        data: data);
  }

  @override
  ASTFunctionDeclarationNode toDeclarationNode() {
    return ASTFunctionDeclarationNode(
        functionName: "buildAnimeVideoGroup",
        parameters: [
          ASTParameterNode("title"),
          ASTParameterNode("videos"),
          ASTParameterNode("data")
        ],
        body: this);
  }
}
