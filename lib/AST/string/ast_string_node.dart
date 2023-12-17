import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:json_annotation/json_annotation.dart';
/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/ast_node.dart';
import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';

part 'ast_string_node.g.dart';

@JsonSerializable(explicitToJson: true)
class ASTStringNode extends ASTNode {
  factory ASTStringNode.fromJson(Map<String, dynamic> json) =>
      _$ASTStringNodeFromJson(json);

  Map<String, dynamic> toJson() => _$ASTStringNodeToJson(this);

  final String value;

  const ASTStringNode({
    required this.value,
  });

  @override
  Future<dynamic> execute(InterpreterEnvironment environment) async {
    return value;
  }
}
