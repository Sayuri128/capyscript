// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ast_object_set_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ASTObjectSetNode _$ASTObjectSetNodeFromJson(Map<String, dynamic> json) =>
    ASTObjectSetNode(
      targetExpression:
          ASTNode.fromJson(json['targetExpression'] as Map<String, dynamic>),
      keyExpression:
          ASTNode.fromJson(json['keyExpression'] as Map<String, dynamic>),
      valueExpression:
          ASTNode.fromJson(json['valueExpression'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ASTObjectSetNodeToJson(ASTObjectSetNode instance) =>
    <String, dynamic>{
      'targetExpression': instance.targetExpression.toJson(),
      'keyExpression': instance.keyExpression.toJson(),
      'valueExpression': instance.valueExpression.toJson(),
    };
