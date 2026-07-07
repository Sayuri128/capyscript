// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ast_throw_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ASTThrowNode _$ASTThrowNodeFromJson(Map<String, dynamic> json) => ASTThrowNode(
      expression: ASTNode.fromJson(json['expression'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ASTThrowNodeToJson(ASTThrowNode instance) =>
    <String, dynamic>{
      'expression': instance.expression.toJson(),
    };
