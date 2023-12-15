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
      op: const TokenTypeJsonConverter().fromJson(json['op'] as String),
    );

Map<String, dynamic> _$ASTBinaryOperatorNodeToJson(
        ASTBinaryOperatorNode instance) =>
    <String, dynamic>{
      'left': instance.left.toJson(),
      'right': instance.right.toJson(),
      'op': const TokenTypeJsonConverter().toJson(instance.op),
    };
