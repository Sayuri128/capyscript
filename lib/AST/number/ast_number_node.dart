/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:json_annotation/json_annotation.dart';
import '../ast_node.dart';
import '../ast_node_type.dart';

part 'ast_number_node.g.dart';

@JsonSerializable(explicitToJson: true)
class ASTNumberNode extends ASTNode {
  @JsonSerializable(explicitToJson: true)
  factory ASTNumberNode.fromJson(Map<String, dynamic> json) =>
      _$ASTNumberNodeFromJson(json);

  Map<String, dynamic> toJson() => _$ASTNumberNodeToJson(this);

  final double value;

  @override
  ASTNodeType getType() {
    return ASTNodeType.NUMBER;
  }

  const ASTNumberNode({
    required this.value,
  });

  @override
  execute(Map<String, Map<String, dynamic>> memory,
      Map<String, ASTFunctionDeclarationNode> functions) {
    return value;
  }
}
