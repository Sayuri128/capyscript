/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/waka_models/models/anime/anime_concrete_view/anime_video/anime_video.dart';

class AnimeBuildVideoNode extends ModuleFunctionBody {
  @override
  Future<dynamic> execute(InterpreterEnvironment environment) async {
    final uid = getVariable("uid", environment);
    final title = getVariable("title", environment);
    final timestamp = getVariable("timestamp", environment, defaultValue: null);
    final data = getVariable("data", environment);
    final type = getVariable("type", environment);
    final src = getVariable("src", environment);
    return AnimeVideo(
        type: type,
        uid: uid,
        src: src,
        title: title,
        timestamp: timestamp,
        data: data);
  }

  @override
  ASTFunctionDeclarationNode toDeclarationNode() {
    return ASTFunctionDeclarationNode(
        functionName: "buildAnimeVideo",
        parameters: [
          ASTParameterNode("uid"),
          ASTParameterNode("title"),
          ASTParameterNode("timestamp"),
          ASTParameterNode("data"),
          ASTParameterNode("type"),
          ASTParameterNode("src"),
        ],
        body: this);
  }
}
