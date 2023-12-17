import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:json_annotation/json_annotation.dart';
/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/ast_node.dart';
import 'package:capyscript/AST/for_loop/ast_break_node.dart';
import 'package:capyscript/AST/for_loop/ast_continue_node.dart';
import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';

part 'ast_for_loop_node.g.dart';

@JsonSerializable(explicitToJson: true)
class ASTForLoopNode extends ASTNode {
  factory ASTForLoopNode.fromJson(Map<String, dynamic> json) =>
      _$ASTForLoopNodeFromJson(json);

  Map<String, dynamic> toJson() => _$ASTForLoopNodeToJson(this);

  final ASTNode initialization;
  final ASTNode condition;
  final ASTNode increment;
  final ASTNode body;

  const ASTForLoopNode({
    required this.initialization,
    required this.condition,
    required this.increment,
    required this.body,
  });

  @override
  Future execute(InterpreterEnvironment environment) async {
    await initialization.execute(environment);
    for (; await condition.execute(environment);) {
      try {
        await body.execute(environment);
        await increment.execute(environment);
      } on ASTContinueNode catch (_) {
        continue;
      } on ASTBreakNode catch (_) {
        break;
      }
    }
  }
}
