// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_module.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseModule _$BaseModuleFromJson(Map<String, dynamic> json) => BaseModule(
      moduleName: json['moduleName'] as String,
    )..body = ASTTree.fromJson(json['body'] as Map<String, dynamic>);

Map<String, dynamic> _$BaseModuleToJson(BaseModule instance) =>
    <String, dynamic>{
      'moduleName': instance.moduleName,
      'body': instance.body.toJson(),
    };
