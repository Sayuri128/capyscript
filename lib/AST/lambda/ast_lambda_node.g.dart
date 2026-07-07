// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ast_lambda_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ASTLambdaNode _$ASTLambdaNodeFromJson(Map<String, dynamic> json) =>
    ASTLambdaNode(
      parameters: (json['parameters'] as List<dynamic>)
          .map((e) => ASTParameterNode.fromJson(e as Map<String, dynamic>))
          .toList(),
      body: ASTNode.fromJson(json['body'] as Map<String, dynamic>),
      returnType: json['returnType'] as String?,
    );

Map<String, dynamic> _$ASTLambdaNodeToJson(ASTLambdaNode instance) =>
    <String, dynamic>{
      'parameters': instance.parameters.map((e) => e.toJson()).toList(),
      'body': instance.body.toJson(),
      'returnType': instance.returnType,
    };
