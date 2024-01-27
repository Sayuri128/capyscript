// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ast_parameter_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ASTParameterNode _$ASTParameterNodeFromJson(Map<String, dynamic> json) =>
    ASTParameterNode(
      json['paramName'] as String,
      defaultValue: json['defaultValue'] == null
          ? null
          : ASTNode.fromJson(json['defaultValue'] as Map<String, dynamic>),
      isOptional: json['isOptional'] as bool? ?? false,
    );

Map<String, dynamic> _$ASTParameterNodeToJson(ASTParameterNode instance) =>
    <String, dynamic>{
      'paramName': instance.paramName,
      'isOptional': instance.isOptional,
      'defaultValue': instance.defaultValue?.toJson(),
    };
