/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/waka_models/models/anime/anime_concrete_view/anime_video/anime_view_type.dart';

class AnimeBuildTypeIframeNode extends ModuleFunctionBody {
  @override
  Future<dynamic> execute(InterpreterEnvironment environment) async {
    return AnimeVideoType.IFRAME;
  }

  @override
  ASTFunctionDeclarationNode toDeclarationNode() {
    return ASTFunctionDeclarationNode(
        functionName: "typeIframe", parameters: [], body: this);
  }
}