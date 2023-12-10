// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ast_block_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ASTBlockNode _$ASTBlockNodeFromJson(Map<String, dynamic> json) => ASTBlockNode(
      statements: (json['statements'] as List<dynamic>)
          .map((e) => ASTNode.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ASTBlockNodeToJson(ASTBlockNode instance) =>
    <String, dynamic>{
      'statements': instance.statements.map((e) => e.toJson()).toList(),
    };
