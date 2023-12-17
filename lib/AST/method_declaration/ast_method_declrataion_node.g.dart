// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ast_method_declrataion_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ASTMethodDeclarationNode _$ASTMethodDeclarationNodeFromJson(
        Map<String, dynamic> json) =>
    ASTMethodDeclarationNode(
      methodName: json['methodName'] as String,
      parameters: (json['parameters'] as List<dynamic>)
          .map((e) => ASTParameterNode.fromJson(e as Map<String, dynamic>))
          .toList(),
      body: ASTNode.fromJson(json['body'] as Map<String, dynamic>),
      className: json['className'] as String,
    );

Map<String, dynamic> _$ASTMethodDeclarationNodeToJson(
        ASTMethodDeclarationNode instance) =>
    <String, dynamic>{
      'className': instance.className,
      'methodName': instance.methodName,
      'parameters': instance.parameters.map((e) => e.toJson()).toList(),
      'body': instance.body.toJson(),
    };
