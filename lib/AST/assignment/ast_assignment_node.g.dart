// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ast_assignment_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ASTAssignmentNode _$ASTAssignmentNodeFromJson(Map<String, dynamic> json) =>
    ASTAssignmentNode(
      variableName: json['variableName'] as String,
      expression: ASTNode.fromJson(json['expression'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ASTAssignmentNodeToJson(ASTAssignmentNode instance) =>
    <String, dynamic>{
      'variableName': instance.variableName,
      'expression': instance.expression.toJson(),
    };
