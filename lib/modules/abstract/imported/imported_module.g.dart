// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'imported_module.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImportedModule _$ImportedModuleFromJson(Map<String, dynamic> json) =>
    ImportedModule(
      body: ASTTree.fromJson(json['body'] as Map<String, dynamic>),
      moduleName: json['moduleName'] as String,
    );

Map<String, dynamic> _$ImportedModuleToJson(ImportedModule instance) =>
    <String, dynamic>{
      'moduleName': instance.moduleName,
      'body': instance.body.toJson(),
    };
