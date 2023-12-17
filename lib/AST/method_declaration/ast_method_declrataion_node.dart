import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:json_annotation/json_annotation.dart';
/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/ast_node.dart';
import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';

part 'ast_method_declrataion_node.g.dart';

@JsonSerializable(explicitToJson: true)
class ASTMethodDeclarationNode extends ASTNode {
  factory ASTMethodDeclarationNode.fromJson(Map<String, dynamic> json) =>
      _$ASTMethodDeclarationNodeFromJson(json);

  Map<String, dynamic> toJson() => _$ASTMethodDeclarationNodeToJson(this);

  final String className;
  final String methodName;
  final List<ASTParameterNode> parameters;
  final ASTNode body;

  const ASTMethodDeclarationNode(
      {required this.methodName,
      required this.parameters,
      required this.body,
      required this.className});

  @override
  Future execute(InterpreterEnvironment environment) async {
    return await body.execute(environment);
  }
}
