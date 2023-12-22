/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_concrete_view/manga_status.dart';

class MangaBuildStatusPausedNode extends ModuleFunctionBody {
  @override
  Future<dynamic> execute(InterpreterEnvironment environment) async {
    return MangaStatus.PAUSED;
  }

  @override
  ASTFunctionDeclarationNode toDeclarationNode() {
    return ASTFunctionDeclarationNode(
        functionName: "statusPaused", parameters: [], body: this);
  }
}
