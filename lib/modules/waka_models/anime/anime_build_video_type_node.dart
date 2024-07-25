/*
 * Copyright (c) 2024 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/waka_models/models/anime/anime_concrete_view/anime_video/anime_view_type.dart';

class AnimeBuildVideoTypeNode extends ModuleFunctionBody {
  @override
  Future<AnimeVideoType> execute(InterpreterEnvironment environment) async {
    final type = getVariable("type", environment);
    switch (type) {
      case "iframe":
        return AnimeVideoType.IFRAME;
      default:
        throw Exception("Unknown type: $type");
    }
  }

  @override
  ASTFunctionDeclarationNode toDeclarationNode() {
    return ASTFunctionDeclarationNode(
        functionName: "buildVideoType",
        parameters: [
          ASTParameterNode("type"),
        ],
        body: this);
  }
}
