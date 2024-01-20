// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ast_object_set_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ASTObjectSetNode _$ASTObjectSetNodeFromJson(Map<String, dynamic> json) =>
    ASTObjectSetNode(
      targetExpression:
          ASTNode.fromJson(json['targetExpression'] as Map<String, dynamic>),
      keyExpressions: (json['keyExpressions'] as List<dynamic>)
          .map((e) => ASTNode.fromJson(e as Map<String, dynamic>))
          .toList(),
      valueExpression:
          ASTNode.fromJson(json['valueExpression'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ASTObjectSetNodeToJson(ASTObjectSetNode instance) =>
    <String, dynamic>{
      'targetExpression': instance.targetExpression.toJson(),
      'keyExpressions': instance.keyExpressions.map((e) => e.toJson()).toList(),
      'valueExpression': instance.valueExpression.toJson(),
    };
