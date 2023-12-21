/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'method_call_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ASTMethodCallNode _$ASTMethodCallNodeFromJson(Map<String, dynamic> json) =>
    ASTMethodCallNode(
      variable: ASTNode.fromJson(json['variable'] as Map<String, dynamic>),
      methodName: json['methodName'] as String,
      arguments: (json['arguments'] as List<dynamic>)
          .map((e) => ASTNode.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ASTMethodCallNodeToJson(ASTMethodCallNode instance) =>
    <String, dynamic>{
      'variable': instance.variable.toJson(),
      'methodName': instance.methodName,
      'arguments': instance.arguments.map((e) => e.toJson()).toList(),
    };
