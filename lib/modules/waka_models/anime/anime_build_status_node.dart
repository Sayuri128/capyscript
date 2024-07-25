/*
 * Copyright (c) 2024 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/waka_models/models/anime/anime_concrete_view/anime_status.dart';

class AnimeBuildStatusNode extends ModuleFunctionBody {
  @override
  Future<AnimeStatus> execute(InterpreterEnvironment environment) async {
    final type = getVariable("type", environment);

    switch (type) {
      case "announce":
        return AnimeStatus.ANNOUNCE;
      case "canceled":
        return AnimeStatus.CANCELED;
      case 'ongoing':
        return AnimeStatus.ONGOING;
      case 'paused':
        return AnimeStatus.PAUSED;
      case "released":
        return AnimeStatus.RELEASED;
      default:
        return AnimeStatus.UNDEFINED;
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
