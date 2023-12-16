/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/ast_return_value.dart';
import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:json_annotation/json_annotation.dart';
import '../ast_node.dart';

part 'ast_function_call_node.g.dart';

@JsonSerializable(explicitToJson: true)
class ASTFunctionCallNode extends ASTNode {
  factory ASTFunctionCallNode.fromJson(Map<String, dynamic> json) =>
      _$ASTFunctionCallNodeFromJson(json);

  Map<String, dynamic> toJson() => _$ASTFunctionCallNodeToJson(this);
  final String functionName;
  final List<ASTNode> arguments;

  const ASTFunctionCallNode({
    required this.functionName,
    required this.arguments,
  });

  @override
  Future<dynamic> execute(Map<String, Map<String, dynamic>> memory,
      Map<String, ASTFunctionDeclarationNode> functions) async {
    late final ASTFunctionDeclarationNode function;

    try {
      function = functions[functionName]!;
      memory[functionName] = {};
    } catch (e) {
      throw Exception("function ${functionName} not found");
    }

    final mem = memory[functionName]!;
    for (int i = 0; i < function.parameters.length; i++) {
      mem[function.parameters[i].paramName] =
          await arguments[i].execute(memory, functions);
    }

    try {
      return await function.execute(memory, functions);
    } on ASTReturnValue<dynamic> catch (res) {
      return res.execute(memory, functions);
    }
  }
}
