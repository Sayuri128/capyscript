// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ast_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ASTResult _$ASTResultFromJson(Map<String, dynamic> json) => ASTResult(
      functions: (json['functions'] as List<dynamic>)
          .map((e) =>
              ASTFunctionDeclarationNode.fromJson(e as Map<String, dynamic>))
          .toList(),
      modules: (json['modules'] as List<dynamic>)
          .map((e) => ASTImportNode.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ASTResultToJson(ASTResult instance) => <String, dynamic>{
      'functions': instance.functions.map((e) => e.toJson()).toList(),
      'modules': instance.modules.map((e) => e.toJson()).toList(),
    };
