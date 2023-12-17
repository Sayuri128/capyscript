import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:json_annotation/json_annotation.dart';
/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */
import 'package:capyscript/AST/ast_node.dart';
import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';

part 'ast_continue_node.g.dart';

@JsonSerializable(explicitToJson: true)
class ASTContinueNode extends ASTNode {
  factory ASTContinueNode.fromJson(Map<String, dynamic> json) =>
      _$ASTContinueNodeFromJson(json);

  Map<String, dynamic> toJson() => _$ASTContinueNodeToJson(this);

  @override
  Future execute(InterpreterEnvironment environment) async {
    throw this;
  }

  const ASTContinueNode();
}
