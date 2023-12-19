/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/AST/object/ast_object_get_node.dart';
import 'package:capyscript/AST/variable_node/ast_variable_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:json_annotation/json_annotation.dart';
import '../ast_node.dart';

part 'ast_assignment_node.g.dart';

@JsonSerializable(explicitToJson: true)
class ASTAssignmentNode extends ASTNode {
  factory ASTAssignmentNode.fromJson(Map<String, dynamic> json) =>
      _$ASTAssignmentNodeFromJson(json);

  Map<String, dynamic> toJson() => _$ASTAssignmentNodeToJson(this);

  final ASTNode target;
  final String functionName;
  final ASTNode expression;

  const ASTAssignmentNode({
    required this.target,
    required this.functionName,
    required this.expression,
  });

  @override
  Future<dynamic> execute(InterpreterEnvironment environment) async {
    final res = await expression.execute(environment);
    await target.getReference().setter(environment, res);
    return res;
  }
}
