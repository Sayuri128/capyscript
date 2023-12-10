/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:json_annotation/json_annotation.dart';
import '../ast_node.dart';
import '../ast_node_type.dart';

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
  ASTNodeType getType() {
    return ASTNodeType.FUNCTION_CALL;
  }
}
