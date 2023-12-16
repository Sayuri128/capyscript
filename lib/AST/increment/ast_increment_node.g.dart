// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ast_increment_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ASTIncrementNode _$ASTIncrementNodeFromJson(Map<String, dynamic> json) =>
    ASTIncrementNode(
      variable: json['variable'] as String,
      functionName: json['functionName'] as String,
    );

Map<String, dynamic> _$ASTIncrementNodeToJson(ASTIncrementNode instance) =>
    <String, dynamic>{
      'variable': instance.variable,
      'functionName': instance.functionName,
    };
