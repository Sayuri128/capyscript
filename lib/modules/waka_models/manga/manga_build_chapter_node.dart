/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/waka_models/models/manga/manga_concrete_view/chapter/chapter.dart';

class MangaBuildChapterNode extends ModuleFunctionBody {
  @override
  Future<dynamic> execute(InterpreterEnvironment environment) async {
    final uid = getVariable("uid", environment);
    final title = getVariable("title", environment);
    final timestamp = getVariable("timestamp", environment);
    final data = getVariable("data", environment);
    return Chapter(uid: uid, title: title, data: data, timestamp: timestamp);
  }

  @override
  ASTFunctionDeclarationNode toDeclarationNode() {
    return ASTFunctionDeclarationNode(
        functionName: "buildChapter",
        parameters: [
          ASTParameterNode("uid"),
          ASTParameterNode("title"),
          ASTParameterNode("timestamp"),
          ASTParameterNode("data"),
        ],
        body: this);
  }
}
