// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ast_binary_operator_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ASTBinaryOperatorNode _$ASTBinaryOperatorNodeFromJson(
        Map<String, dynamic> json) =>
    ASTBinaryOperatorNode(
      left: ASTNode.fromJson(json['left'] as Map<String, dynamic>),
      right: ASTNode.fromJson(json['right'] as Map<String, dynamic>),
      op: $enumDecode(_$TokenTypeEnumMap, json['op']),
    );

Map<String, dynamic> _$ASTBinaryOperatorNodeToJson(
        ASTBinaryOperatorNode instance) =>
    <String, dynamic>{
      'left': instance.left.toJson(),
      'right': instance.right.toJson(),
      'op': _$TokenTypeEnumMap[instance.op]!,
    };

const _$TokenTypeEnumMap = {
  TokenType.NUMBER: 'NUMBER',
  TokenType.FUNCTION: 'FUNCTION',
  TokenType.IDENTIFIER: 'IDENTIFIER',
  TokenType.PLUS: 'PLUS',
  TokenType.MINUS: 'MINUS',
  TokenType.MULTIPLY: 'MULTIPLY',
  TokenType.DIVIDE: 'DIVIDE',
  TokenType.LPAREN: 'LPAREN',
  TokenType.RPAREN: 'RPAREN',
  TokenType.SEMICOLON: 'SEMICOLON',
  TokenType.END: 'END',
  TokenType.COMMA: 'COMMA',
  TokenType.LBRACE: 'LBRACE',
  TokenType.RBRACE: 'RBRACE',
  TokenType.EQUALS: 'EQUALS',
  TokenType.IMPORT: 'IMPORT',
  TokenType.SINGLE_QUOTE: 'SINGLE_QUOTE',
  TokenType.DOUBLE_QUOTES: 'DOUBLE_QUOTES',
};
