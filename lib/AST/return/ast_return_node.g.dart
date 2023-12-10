// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ast_return_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ASTReturnNode _$ASTReturnNodeFromJson(Map<String, dynamic> json) =>
    ASTReturnNode(
      expression: ASTNode.fromJson(json['expression'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ASTReturnNodeToJson(ASTReturnNode instance) =>
    <String, dynamic>{
      'expression': instance.expression.toJson(),
    };
