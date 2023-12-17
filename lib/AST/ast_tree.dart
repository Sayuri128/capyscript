import 'package:capyscript/AST/class_declaration/ast_class_declaration_node.dart';
import 'package:json_annotation/json_annotation.dart';
/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/AST/import/ast_import_node.dart';

part 'ast_tree.g.dart';

@JsonSerializable(explicitToJson: true)
class ASTTree {
  factory ASTTree.fromJson(Map<String, dynamic> json) =>
      _$ASTTreeFromJson(json);

  Map<String, dynamic> toJson() => _$ASTTreeToJson(this);

  final List<ASTFunctionDeclarationNode> functions;
  final List<ASTClassDeclarationNode> classes;
  final List<ASTImportNode> modules;

  const ASTTree({
    required this.functions,
    required this.classes,
    required this.modules,
  });
}
