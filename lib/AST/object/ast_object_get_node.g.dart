// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ast_object_get_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ASTObjectGetNode _$ASTObjectGetNodeFromJson(Map<String, dynamic> json) =>
    ASTObjectGetNode(
      object: ASTNode.fromJson(json['object'] as Map<String, dynamic>),
      key: ASTNode.fromJson(json['key'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ASTObjectGetNodeToJson(ASTObjectGetNode instance) =>
    <String, dynamic>{
      'object': instance.object.toJson(),
      'key': instance.key.toJson(),
    };
