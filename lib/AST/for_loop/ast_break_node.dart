import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:json_annotation/json_annotation.dart';
/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/ast_node.dart';
import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';

part 'ast_break_node.g.dart';

@JsonSerializable(explicitToJson: true)
class ASTBreakNode extends ASTNode {
  factory ASTBreakNode.fromJson(Map<String, dynamic> json) =>
      _$ASTBreakNodeFromJson(json);
  Map<String, dynamic> toJson() => _$ASTBreakNodeToJson(this);

  @override
  Future execute(InterpreterEnvironment environment) {
    throw this;
  }

  const ASTBreakNode();
}
