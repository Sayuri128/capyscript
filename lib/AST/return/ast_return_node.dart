/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/ast_return_value.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:capyscript/AST/ast_node.dart';
import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';

part 'ast_return_node.g.dart';

@JsonSerializable(explicitToJson: true)
class ASTReturnNode extends ASTNode {
  factory ASTReturnNode.fromJson(Map<String, dynamic> json) =>
      _$ASTReturnNodeFromJson(json);

  Map<String, dynamic> toJson() => _$ASTReturnNodeToJson(this);

  final ASTNode expression;

  const ASTReturnNode({
    required this.expression,
  });

  @override
  Future<void> execute(Map<String, Map<String, dynamic>> memory,
      Map<String, ASTFunctionDeclarationNode> functions) async {
    throw ASTReturnValue<dynamic>(
        value: await expression.execute(memory, functions));
  }
}
