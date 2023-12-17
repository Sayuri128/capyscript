// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ast_property_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ASTPropertyNode _$ASTPropertyNodeFromJson(Map<String, dynamic> json) =>
    ASTPropertyNode(
      className: json['className'] as String,
      name: json['name'] as String,
      defaultValue:
          ASTNode.fromJson(json['defaultValue'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ASTPropertyNodeToJson(ASTPropertyNode instance) =>
    <String, dynamic>{
      'className': instance.className,
      'name': instance.name,
      'defaultValue': instance.defaultValue.toJson(),
    };
