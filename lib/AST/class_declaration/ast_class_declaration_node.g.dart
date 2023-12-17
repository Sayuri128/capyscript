// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ast_class_declaration_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ASTClassDeclarationNode _$ASTClassDeclarationNodeFromJson(
        Map<String, dynamic> json) =>
    ASTClassDeclarationNode(
      className: json['className'] as String,
      methods: (json['methods'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k, ASTMethodDeclarationNode.fromJson(e as Map<String, dynamic>)),
      ),
      properties: (json['properties'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, ASTPropertyNode.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$ASTClassDeclarationNodeToJson(
        ASTClassDeclarationNode instance) =>
    <String, dynamic>{
      'className': instance.className,
      'methods': instance.methods.map((k, e) => MapEntry(k, e.toJson())),
      'properties': instance.properties.map((k, e) => MapEntry(k, e.toJson())),
    };
