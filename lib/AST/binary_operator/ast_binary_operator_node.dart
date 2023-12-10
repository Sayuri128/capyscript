/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:json_annotation/json_annotation.dart';
import '../../Lexer/token_type.dart';
import '../ast_node.dart';
import '../ast_node_type.dart';

part 'ast_binary_operator_node.g.dart';

@JsonSerializable(explicitToJson: true)
class ASTBinaryOperatorNode extends ASTNode {
  factory ASTBinaryOperatorNode.fromJson(Map<String, dynamic> json) =>
      _$ASTBinaryOperatorNodeFromJson(json);

  Map<String, dynamic> toJson() => _$ASTBinaryOperatorNodeToJson(this);
  final ASTNode left;
  final ASTNode right;
  final TokenType op;

  // @override
  // dynamic execute() {
  //   final leftRes = left.execute();
  //   final rightRes = right.execute();
  //   print(leftRes.toString() + " ${op} " + rightRes.toString());
  //
  //   switch (op) {
  //     case TokenType.PLUS:
  //       return leftRes + rightRes;
  //     case TokenType.MINUS:
  //       return leftRes - rightRes;
  //     case TokenType.MULTIPLY:
  //       return leftRes * rightRes;
  //     case TokenType.DIVIDE:
  //       return leftRes / rightRes;
  //     default:
  //       return leftRes + rightRes;
  //   }
  // }

  @override
  ASTNodeType getType() {
    return ASTNodeType.BINARY_OPERATION;
  }

  const ASTBinaryOperatorNode({
    required this.left,
    required this.right,
    required this.op,
  });
}
