/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:json_annotation/json_annotation.dart';
import '../ast_node.dart';

part 'ast_block_node.g.dart';

@JsonSerializable(explicitToJson: true)
class ASTBlockNode extends ASTNode {
  factory ASTBlockNode.fromJson(Map<String, dynamic> json) =>
      _$ASTBlockNodeFromJson(json);

  Map<String, dynamic> toJson() => _$ASTBlockNodeToJson(this);
  final List<ASTNode> statements;

  const ASTBlockNode({
    required this.statements,
  });

  @override
  Future<dynamic> execute(Map<String, Map<String, dynamic>> memory,
      Map<String, ASTFunctionDeclarationNode> functions) async {
    dynamic result;
    for (var statement in statements) {
      result = await statement.execute(memory, functions);
    }
    return result; // Return the result of the last statement
  }
}
