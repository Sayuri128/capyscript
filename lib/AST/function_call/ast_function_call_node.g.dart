// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ast_function_call_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ASTFunctionCallNode _$ASTFunctionCallNodeFromJson(Map<String, dynamic> json) =>
    ASTFunctionCallNode(
      function: ASTNode.fromJson(json['function'] as Map<String, dynamic>),
      arguments: (json['arguments'] as List<dynamic>)
          .map((e) => ASTNode.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ASTFunctionCallNodeToJson(
        ASTFunctionCallNode instance) =>
    <String, dynamic>{
      'function': instance.function.toJson(),
      'arguments': instance.arguments.map((e) => e.toJson()).toList(),
    };
