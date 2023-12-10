/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:json_annotation/json_annotation.dart';
import '../ast_node.dart';
import '../ast_node_type.dart';

part 'ast_assignment_node.g.dart';

@JsonSerializable(explicitToJson: true)
class ASTAssignmentNode extends ASTNode {
  factory ASTAssignmentNode.fromJson(Map<String, dynamic> json) =>
      _$ASTAssignmentNodeFromJson(json);

  Map<String, dynamic> toJson() => _$ASTAssignmentNodeToJson(this);

  final String variableName;
  final ASTNode expression;

  const ASTAssignmentNode({
    required this.variableName,
    required this.expression,
  });

  @override
  ASTNodeType getType() {
    return ASTNodeType.ASSIGNMENT;
  }
}
