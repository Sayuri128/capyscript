// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ast_tree.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ASTTree _$ASTTreeFromJson(Map<String, dynamic> json) => ASTTree(
      functions: (json['functions'] as List<dynamic>)
          .map((e) =>
              ASTFunctionDeclarationNode.fromJson(e as Map<String, dynamic>))
          .toList(),
      classes: (json['classes'] as List<dynamic>)
          .map((e) =>
              ASTClassDeclarationNode.fromJson(e as Map<String, dynamic>))
          .toList(),
      modules: (json['modules'] as List<dynamic>)
          .map((e) => ASTImportNode.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ASTTreeToJson(ASTTree instance) => <String, dynamic>{
      'functions': instance.functions.map((e) => e.toJson()).toList(),
      'classes': instance.classes.map((e) => e.toJson()).toList(),
      'modules': instance.modules.map((e) => e.toJson()).toList(),
    };
