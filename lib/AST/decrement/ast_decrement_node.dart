import 'package:json_annotation/json_annotation.dart';
/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/ast_node.dart';
import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';

part 'ast_decrement_node.g.dart';

@JsonSerializable(explicitToJson: true)
class ASTDecrementNode extends ASTNode {

	factory ASTDecrementNode.fromJson(Map<String, dynamic> json) => _$ASTDecrementNodeFromJson(json);
	Map<String, dynamic> toJson() => _$ASTDecrementNodeToJson(this);

  final String variable;
  final String functionName;

  @override
  Future execute(Map<String, Map<String, dynamic>> memory,
      Map<String, ASTFunctionDeclarationNode> functions) async {
    final value = memory[functionName]![variable];
    memory[functionName]![variable]--;
    return value;
  }

  const ASTDecrementNode({
    required this.variable,
    required this.functionName,
  });
}
