import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:json_annotation/json_annotation.dart';
/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/ast_node.dart';

part 'ast_if_node.g.dart';

@JsonSerializable(explicitToJson: true)
class ASTIfNode extends ASTNode {
  factory ASTIfNode.fromJson(Map<String, dynamic> json) =>
      _$ASTIfNodeFromJson(json);

  Map<String, dynamic> toJson() => _$ASTIfNodeToJson(this);

  final ASTNode condition;
  final ASTNode trueBranch;
  final ASTNode? elseBranch;

  const ASTIfNode({
    required this.condition,
    required this.trueBranch,
    this.elseBranch,
  });

  @override
  Future execute(Map<String, Map<String, dynamic>> memory,
      Map<String, ASTFunctionDeclarationNode> functions) async {
    final res = await condition.execute(memory, functions);

    if (res) {
      return await trueBranch.execute(memory, functions);
    }

    if (elseBranch != null) {
      return await elseBranch!.execute(memory, functions);
    }

    return null;
  }
}
