/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ast_property_access_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ASTPropertyAccessNode _$ASTPropertyAccessNodeFromJson(
        Map<String, dynamic> json) =>
    ASTPropertyAccessNode(
      targetExpression:
          ASTNode.fromJson(json['targetExpression'] as Map<String, dynamic>),
      fieldName: json['fieldName'] as String,
    );

Map<String, dynamic> _$ASTPropertyAccessNodeToJson(
        ASTPropertyAccessNode instance) =>
    <String, dynamic>{
      'targetExpression': instance.targetExpression.toJson(),
      'fieldName': instance.fieldName,
    };
