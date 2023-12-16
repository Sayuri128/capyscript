import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:json_annotation/json_annotation.dart';

/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/ast_node.dart';

part 'ast_object_set_node.g.dart';

@JsonSerializable(explicitToJson: true)
class ASTObjectSetNode extends ASTNode {
  factory ASTObjectSetNode.fromJson(Map<String, dynamic> json) =>
      _$ASTObjectSetNodeFromJson(json);

  Map<String, dynamic> toJson() => _$ASTObjectSetNodeToJson(this);

  final ASTNode targetExpression;
  final ASTNode keyExpression;
  final ASTNode valueExpression;

  const ASTObjectSetNode({
    required this.targetExpression,
    required this.keyExpression,
    required this.valueExpression,
  });

  @override
  Future execute(Map<String, Map<String, dynamic>> memory,
      Map<String, ASTFunctionDeclarationNode> functions) async {
    final target = await targetExpression.execute(memory, functions);
    final key = await keyExpression.execute(memory, functions);
    final value = await valueExpression.execute(memory, functions);
    target[key] = value;
    return null;
  }
}
