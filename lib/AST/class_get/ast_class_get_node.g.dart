// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ast_class_get_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ASTClassGetNode _$ASTClassGetNodeFromJson(Map<String, dynamic> json) =>
    ASTClassGetNode(
      targetExpression:
          ASTNode.fromJson(json['targetExpression'] as Map<String, dynamic>),
      fieldNames: (json['fieldNames'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ASTClassGetNodeToJson(ASTClassGetNode instance) =>
    <String, dynamic>{
      'targetExpression': instance.targetExpression.toJson(),
      'fieldNames': instance.fieldNames,
    };
