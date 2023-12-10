import 'package:json_annotation/json_annotation.dart';
/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/ast_node.dart';
import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';

part 'ast_variable_node.g.dart';

@JsonSerializable(explicitToJson: true)
class ASTVariableNode extends ASTNode {
  factory ASTVariableNode.fromJson(Map<String, dynamic> json) =>
      _$ASTVariableNodeFromJson(json);

  Map<String, dynamic> toJson() => _$ASTVariableNodeToJson(this);

  final String functionName;
  final String variableName;

  const ASTVariableNode(
      {required this.variableName, required this.functionName});

  @override
  execute(Map<String, Map<String, dynamic>> memory,
      Map<String, ASTFunctionDeclarationNode> functions) {
    return memory[functionName]?[variableName];
  }
}
