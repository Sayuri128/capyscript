import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:json_annotation/json_annotation.dart';
/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/ast_node.dart';

part 'ast_array_node.g.dart';

@JsonSerializable(explicitToJson: true)
class ASTArrayNode extends ASTNode {
  factory ASTArrayNode.fromJson(Map<String, dynamic> json) =>
      _$ASTArrayNodeFromJson(json);

  Map<String, dynamic> toJson() => _$ASTArrayNodeToJson(this);

  final List<ASTNode> expressions;

  const ASTArrayNode({required this.expressions});

  @override
  Future execute(Map<String, Map<String, dynamic>> memory,
      Map<String, ASTFunctionDeclarationNode> functions) async {
    return (await Future.wait(
            expressions.map((e) => e.execute(memory, functions))))
        .toList();
  }
}
