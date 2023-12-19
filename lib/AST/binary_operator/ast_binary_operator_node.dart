/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/function_call/ast_function_call_node.dart';
import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/AST/variable_node/ast_variable_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
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
  Future<dynamic> execute(InterpreterEnvironment environment) async {
    final leftRes = await left.execute(environment);
    final rightRes = await right.execute(environment);
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
      case TokenType.EQUAL_EQUAL:
        return leftRes == rightRes;
      case TokenType.LESS:
        return leftRes < rightRes;
      case TokenType.GREATER:
        return leftRes > rightRes;
      case TokenType.LESS_EQUAL:
        return leftRes <= rightRes;
      case TokenType.GREATER_EQUAL:
        return leftRes >= rightRes;
      case TokenType.LSQUARE_BRACE:
        return leftRes[rightRes];
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
