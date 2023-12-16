import 'package:json_annotation/json_annotation.dart';
/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/ast_node.dart';
import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';

part 'ast_object_get_node.g.dart';

@JsonSerializable(explicitToJson: true)
class ASTObjectGetNode extends ASTNode {
  factory ASTObjectGetNode.fromJson(Map<String, dynamic> json) =>
      _$ASTObjectGetNodeFromJson(json);

  Map<String, dynamic> toJson() => _$ASTObjectGetNodeToJson(this);

  final ASTNode targetExpression;
  final ASTNode keyExpression;

  const ASTObjectGetNode({
    required this.targetExpression,
    required this.keyExpression,
  });

  @override
  Future execute(Map<String, Map<String, dynamic>> memory,
      Map<String, ASTFunctionDeclarationNode> functions) async {
    final target = await targetExpression.execute(memory, functions);
    final key = await keyExpression.execute(memory, functions);
    return target[key];
  }
}
