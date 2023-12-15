// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ast_if_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ASTIfNode _$ASTIfNodeFromJson(Map<String, dynamic> json) => ASTIfNode(
      condition: ASTNode.fromJson(json['condition'] as Map<String, dynamic>),
      trueBranch: ASTNode.fromJson(json['trueBranch'] as Map<String, dynamic>),
      elseBranch: json['elseBranch'] == null
          ? null
          : ASTNode.fromJson(json['elseBranch'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ASTIfNodeToJson(ASTIfNode instance) => <String, dynamic>{
      'condition': instance.condition.toJson(),
      'trueBranch': instance.trueBranch.toJson(),
      'elseBranch': instance.elseBranch?.toJson(),
    };
