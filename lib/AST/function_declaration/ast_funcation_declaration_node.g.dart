// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ast_funcation_declaration_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ASTFunctionDeclarationNode _$ASTFunctionDeclarationNodeFromJson(
        Map<String, dynamic> json) =>
    ASTFunctionDeclarationNode(
      functionName: json['functionName'] as String,
      parameters: (json['parameters'] as List<dynamic>)
          .map((e) => ASTParameterNode.fromJson(e as Map<String, dynamic>))
          .toList(),
      body: ASTNode.fromJson(json['body'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ASTFunctionDeclarationNodeToJson(
        ASTFunctionDeclarationNode instance) =>
    <String, dynamic>{
      'functionName': instance.functionName,
      'parameters': instance.parameters.map((e) => e.toJson()).toList(),
      'body': instance.body.toJson(),
    };
