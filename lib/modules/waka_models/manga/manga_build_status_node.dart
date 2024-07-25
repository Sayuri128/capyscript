/*
 * Copyright (c) 2024 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_concrete_view/manga_status.dart';

class MangaBuildStatusNode extends ModuleFunctionBody {
  @override
  Future<MangaStatus> execute(InterpreterEnvironment environment) async {
    final type = getVariable("type", environment);

    switch (type) {
      case "announce":
        return MangaStatus.ANNOUNCE;
      case "canceled":
        return MangaStatus.CANCELED;
      case 'ongoing':
        return MangaStatus.ONGOING;
      case 'paused':
        return MangaStatus.PAUSED;
      case "released":
        return MangaStatus.RELEASED;
      default:
        return MangaStatus.UNDEFINED;
    }
  }

  @override
  ASTFunctionDeclarationNode toDeclarationNode() {
    return ASTFunctionDeclarationNode(
      functionName: "buildStatus",
      parameters: [
        ASTParameterNode("type"),
      ],
      body: this,
    );
  }
}
