// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ast_array_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ASTArrayNode _$ASTArrayNodeFromJson(Map<String, dynamic> json) => ASTArrayNode(
      expressions: (json['expressions'] as List<dynamic>)
          .map((e) => ASTNode.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ASTArrayNodeToJson(ASTArrayNode instance) =>
    <String, dynamic>{
      'expressions': instance.expressions.map((e) => e.toJson()).toList(),
    };
