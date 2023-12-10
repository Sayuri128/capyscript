// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ast_variable_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ASTVariableNode _$ASTVariableNodeFromJson(Map<String, dynamic> json) =>
    ASTVariableNode(
      variableName: json['variableName'] as String,
      functionName: json['functionName'] as String,
    );

Map<String, dynamic> _$ASTVariableNodeToJson(ASTVariableNode instance) =>
    <String, dynamic>{
      'functionName': instance.functionName,
      'variableName': instance.variableName,
    };
