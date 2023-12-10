import 'package:json_annotation/json_annotation.dart';
/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/AST/import/ast_import_node.dart';

part 'ast_result.g.dart';

@JsonSerializable(explicitToJson: true)
class ASTResult {
  @JsonSerializable()
  factory ASTResult.fromJson(Map<String, dynamic> json) =>
      _$ASTResultFromJson(json);

  Map<String, dynamic> toJson() => _$ASTResultToJson(this);

  final List<ASTFunctionDeclarationNode> functions;
  final List<ASTImportNode> modules;

  const ASTResult({
    required this.functions,
    required this.modules,
  });
}
