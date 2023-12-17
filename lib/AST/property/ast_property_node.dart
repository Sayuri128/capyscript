import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:json_annotation/json_annotation.dart';
/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/ast_node.dart';
import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';

part 'ast_property_node.g.dart';

@JsonSerializable(explicitToJson: true)
class ASTPropertyNode extends ASTNode {
  final String className;

  factory ASTPropertyNode.fromJson(Map<String, dynamic> json) =>
      _$ASTPropertyNodeFromJson(json);

  Map<String, dynamic> toJson() => _$ASTPropertyNodeToJson(this);
  final String name;
  final ASTNode defaultValue;

  const ASTPropertyNode(
      {required this.className,
      required this.name,
      required this.defaultValue});

  @override
  Future execute(InterpreterEnvironment environment) async {
    return defaultValue.execute(environment);
  }
}
