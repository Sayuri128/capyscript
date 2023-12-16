// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ast_object_get_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ASTObjectGetNode _$ASTObjectGetNodeFromJson(Map<String, dynamic> json) =>
    ASTObjectGetNode(
      targetExpression:
          ASTNode.fromJson(json['targetExpression'] as Map<String, dynamic>),
      keyExpression:
          ASTNode.fromJson(json['keyExpression'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ASTObjectGetNodeToJson(ASTObjectGetNode instance) =>
    <String, dynamic>{
      'targetExpression': instance.targetExpression.toJson(),
      'keyExpression': instance.keyExpression.toJson(),
    };
