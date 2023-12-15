/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../Lexer/token_type.dart';
import '../ast_node.dart';

part 'ast_binary_operator_node.g.dart';

@JsonSerializable(explicitToJson: true)
class ASTBinaryOperatorNode extends ASTNode {
  factory ASTBinaryOperatorNode.fromJson(Map<String, dynamic> json) =>
      _$ASTBinaryOperatorNodeFromJson(json);

  Map<String, dynamic> toJson() => _$ASTBinaryOperatorNodeToJson(this);
  final ASTNode left;
  final ASTNode right;

  @TokenTypeJsonConverter()
  final TokenType op;

  @override
  Future<dynamic> execute(Map<String, Map<String, dynamic>> memory,
      Map<String, ASTFunctionDeclarationNode> functions) async {
    final leftRes = await left.execute(memory, functions);
    final rightRes = await right.execute(memory, functions);
    // print(leftRes.toString() + " ${op} " + rightRes.toString());

    switch (op) {
      case TokenType.PLUS:
        return leftRes + rightRes;
      case TokenType.MINUS:
        return leftRes - rightRes;
      case TokenType.MULTIPLY:
        return leftRes * rightRes;
      case TokenType.DIVIDE:
        return leftRes / rightRes;
      default:
        return leftRes + rightRes;
    }
  }

  const ASTBinaryOperatorNode({
    required this.left,
    required this.right,
    required this.op,
  });
}

class TokenTypeJsonConverter extends JsonConverter<TokenType, String> {
  const TokenTypeJsonConverter();

  @override
  TokenType fromJson(String json) {
    return TokenType.values.firstWhere((element) => element.toString() == json);
  }

  @override
  String toJson(TokenType object) {
    return object.toString();
  }
}
