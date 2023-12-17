// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ast_class_intantiation_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ASTClassInstantiationNode _$ASTClassInstantiationNodeFromJson(
        Map<String, dynamic> json) =>
    ASTClassInstantiationNode(
      className: json['className'] as String,
      arguments: (json['arguments'] as List<dynamic>)
          .map((e) => ASTNode.fromJson(e as Map<String, dynamic>))
          .toList(),
      functionName: json['functionName'] as String,
    );

Map<String, dynamic> _$ASTClassInstantiationNodeToJson(
        ASTClassInstantiationNode instance) =>
    <String, dynamic>{
      'className': instance.className,
      'arguments': instance.arguments.map((e) => e.toJson()).toList(),
      'functionName': instance.functionName,
    };
