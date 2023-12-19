// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ast_assignment_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ASTAssignmentNode _$ASTAssignmentNodeFromJson(Map<String, dynamic> json) =>
    ASTAssignmentNode(
      target: ASTNode.fromJson(json['target'] as Map<String, dynamic>),
      functionName: json['functionName'] as String,
      expression: ASTNode.fromJson(json['expression'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ASTAssignmentNodeToJson(ASTAssignmentNode instance) =>
    <String, dynamic>{
      'target': instance.target.toJson(),
      'functionName': instance.functionName,
      'expression': instance.expression.toJson(),
    };
