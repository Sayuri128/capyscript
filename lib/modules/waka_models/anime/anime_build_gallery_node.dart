/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/waka_models/models/anime/anime_gallery_view/anime_gallery_view.dart';

class AnimeBuildGalleryNode extends ModuleFunctionBody {
  @override
  Future execute(InterpreterEnvironment environment) async {
    final uid = getVariable("uid", environment);
    final title = getVariable("title", environment);
    final cover = getVariable("cover", environment);
    final data = getVariable("data", environment);
    final status = getVariable("status", environment);
    return AnimeGalleryView(
        uid: uid, cover: cover, title: title, data: data, status: status);
  }

  @override
  ASTFunctionDeclarationNode toDeclarationNode() {
    return ASTFunctionDeclarationNode(
        functionName: "buildGallery",
        parameters: [
          ASTParameterNode("uid"),
          ASTParameterNode("title"),
          ASTParameterNode("cover"),
          ASTParameterNode("data"),
          ASTParameterNode("status")
        ],
        body: this);
  }
}
