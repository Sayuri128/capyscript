/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_concrete_view/chapter/pages/pages.dart';

class MangaBuildPagesNode extends ModuleFunctionBody {
  @override
  Future<dynamic> execute(InterpreterEnvironment environment) async {
    final uid = getVariable("uid", environment);
    final value = getVariable("value", environment);
    return Pages(chapterUid: uid, value: value);
  }

  @override
  ASTFunctionDeclarationNode toDeclarationNode() {
    return ASTFunctionDeclarationNode(
        functionName: "buildPages",
        parameters: [
          ASTParameterNode("uid"),
          ASTParameterNode("value"),
        ],
        body: this);
  }
}
