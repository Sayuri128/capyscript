/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:json_annotation/json_annotation.dart';
import '../ast_node.dart';
import '../ast_node_type.dart';
import '../parameter/ast_parameter_node.dart';

part 'ast_funcation_declaration_node.g.dart';

@JsonSerializable(explicitToJson: true)
class ASTFunctionDeclarationNode extends ASTNode {
  factory ASTFunctionDeclarationNode.fromJson(Map<String, dynamic> json) =>
      _$ASTFunctionDeclarationNodeFromJson(json);

  Map<String, dynamic> toJson() => _$ASTFunctionDeclarationNodeToJson(this);

  final String functionName;
  @JsonSerializable()
  final List<ASTParameterNode> parameters;
  final ASTNode body;

  const ASTFunctionDeclarationNode({
    required this.functionName,
    required this.parameters,
    required this.body,
  });

  @override
  ASTNodeType getType() {
    return ASTNodeType.FUNCTION_DECLARATION;
  }

  @override
  execute(Map<String, Map<String, dynamic>> memory,
      Map<String, ASTFunctionDeclarationNode> functions) {
    return body.execute(memory, functions);
  }
}
