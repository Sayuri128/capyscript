// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ast_decrement_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ASTDecrementNode _$ASTDecrementNodeFromJson(Map<String, dynamic> json) =>
    ASTDecrementNode(
      variable: json['variable'] as String,
      functionName: json['functionName'] as String,
    );

Map<String, dynamic> _$ASTDecrementNodeToJson(ASTDecrementNode instance) =>
    <String, dynamic>{
      'variable': instance.variable,
      'functionName': instance.functionName,
    };
