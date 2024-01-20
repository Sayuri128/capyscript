/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_gallery_view/manga_gallery_view.dart';

class MangaBuildGalleryNode extends ModuleFunctionBody {
  @override
  Future<dynamic> execute(InterpreterEnvironment environment) async {
    final uid = getVariable('uid', environment);
    final title = getVariable('title', environment);
    final cover = getVariable('cover', environment);
    final data = Map.fromEntries(
      (getVariable('data', environment) as Map).entries.map(
            (e) => MapEntry(e.key.toString(), e.value),
          ),
    );
    return MangaGalleryView(uid: uid, cover: cover, title: title, data: data);
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
        ],
        body: this);
  }
}
