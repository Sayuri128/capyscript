// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ast_try_catch_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ASTTryCatchNode _$ASTTryCatchNodeFromJson(Map<String, dynamic> json) =>
    ASTTryCatchNode(
      tryBlock: ASTNode.fromJson(json['tryBlock'] as Map<String, dynamic>),
      catchVariable: json['catchVariable'] as String?,
      catchBlock: json['catchBlock'] == null
          ? null
          : ASTNode.fromJson(json['catchBlock'] as Map<String, dynamic>),
      finallyBlock: json['finallyBlock'] == null
          ? null
          : ASTNode.fromJson(json['finallyBlock'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ASTTryCatchNodeToJson(ASTTryCatchNode instance) =>
    <String, dynamic>{
      'tryBlock': instance.tryBlock.toJson(),
      'catchVariable': instance.catchVariable,
      'catchBlock': instance.catchBlock?.toJson(),
      'finallyBlock': instance.finallyBlock?.toJson(),
    };
