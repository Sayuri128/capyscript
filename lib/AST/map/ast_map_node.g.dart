// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ast_map_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ASTMapNode _$ASTMapNodeFromJson(Map<String, dynamic> json) => ASTMapNode(
      keys: (json['keys'] as List<dynamic>)
          .map((e) => ASTNode.fromJson(e as Map<String, dynamic>))
          .toList(),
      values: (json['values'] as List<dynamic>)
          .map((e) => ASTNode.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ASTMapNodeToJson(ASTMapNode instance) =>
    <String, dynamic>{
      'keys': instance.keys.map((e) => e.toJson()).toList(),
      'values': instance.values.map((e) => e.toJson()).toList(),
    };
