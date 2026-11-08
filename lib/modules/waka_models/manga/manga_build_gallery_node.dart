/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/AST/null/ast_null_nodel.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/waka_models/gallery_metadata.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_concrete_view/manga_status.dart';
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
    final status = getVariable('status', environment);
    final metadata = GalleryMetadata.read(environment);
    return MangaGalleryView(
      uid: uid,
      cover: cover,
      title: title,
      data: data,
      status: status is MangaStatus ? status : null,
      subtitle: metadata.subtitle,
      tags: metadata.tags,
      year: metadata.year,
      rating: metadata.rating,
      latestChapter: metadata.latestChapter,
    );
  }

  @override
  ASTFunctionDeclarationNode toDeclarationNode() {
    return ASTFunctionDeclarationNode(
        functionName: "buildGallery",
        parameters: [
          ASTParameterNode("uid", paramType: "string"),
          ASTParameterNode("title", paramType: "string"),
          ASTParameterNode("cover", paramType: "string"),
          ASTParameterNode("data", paramType: "Map"),
          ASTParameterNode("status",
              paramType: "any",
              isOptional: true,
              defaultValue: const ASTNullNode()),
          ...GalleryMetadata.parameters(),
        ],
        returnType: "any",
        body: this);
  }
}
