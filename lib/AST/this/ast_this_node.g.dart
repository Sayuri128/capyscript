// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ast_this_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ASTThisNode _$ASTThisNodeFromJson(Map<String, dynamic> json) => ASTThisNode(
      value: ASTNode.fromJson(json['value'] as Map<String, dynamic>),
      fields:
          (json['fields'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ASTThisNodeToJson(ASTThisNode instance) =>
    <String, dynamic>{
      'value': instance.value.toJson(),
      'fields': instance.fields,
    };
