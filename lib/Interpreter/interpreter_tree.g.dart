// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interpreter_tree.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InterpreterTree _$InterpreterTreeFromJson(Map<String, dynamic> json) =>
    InterpreterTree(
      astTree: ASTTree.fromJson(json['astTree'] as Map<String, dynamic>),
      parsedModules: (json['parsedModules'] as List<dynamic>)
          .map((e) => BaseModule.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$InterpreterTreeToJson(InterpreterTree instance) =>
    <String, dynamic>{
      'astTree': instance.astTree.toJson(),
      'parsedModules': instance.parsedModules.map((e) => e.toJson()).toList(),
    };
