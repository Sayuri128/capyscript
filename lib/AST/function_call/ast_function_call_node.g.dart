// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ast_function_call_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ASTFunctionCallNode _$ASTFunctionCallNodeFromJson(Map<String, dynamic> json) =>
    ASTFunctionCallNode(
      functionName: json['functionName'] as String,
      arguments: (json['arguments'] as List<dynamic>)
          .map((e) => ASTNode.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ASTFunctionCallNodeToJson(
        ASTFunctionCallNode instance) =>
    <String, dynamic>{
      'functionName': instance.functionName,
      'arguments': instance.arguments.map((e) => e.toJson()).toList(),
    };
