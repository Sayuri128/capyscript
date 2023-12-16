// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ast_for_loop_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ASTForLoopNode _$ASTForLoopNodeFromJson(Map<String, dynamic> json) =>
    ASTForLoopNode(
      initialization:
          ASTNode.fromJson(json['initialization'] as Map<String, dynamic>),
      condition: ASTNode.fromJson(json['condition'] as Map<String, dynamic>),
      increment: ASTNode.fromJson(json['increment'] as Map<String, dynamic>),
      body: ASTNode.fromJson(json['body'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ASTForLoopNodeToJson(ASTForLoopNode instance) =>
    <String, dynamic>{
      'initialization': instance.initialization.toJson(),
      'condition': instance.condition.toJson(),
      'increment': instance.increment.toJson(),
      'body': instance.body.toJson(),
    };
