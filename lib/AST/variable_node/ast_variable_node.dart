import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:json_annotation/json_annotation.dart';
/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/ast_node.dart';

part 'ast_variable_node.g.dart';

@JsonSerializable(explicitToJson: true)
class ASTVariableNode extends ASTNode {
  factory ASTVariableNode.fromJson(Map<String, dynamic> json) =>
      _$ASTVariableNodeFromJson(json);

  Map<String, dynamic> toJson() => _$ASTVariableNodeToJson(this);

  final String functionName;
  final String variableName;

  const ASTVariableNode(
      {required this.variableName, required this.functionName});

  @override
  Future<dynamic> execute(InterpreterEnvironment environment) async {
    if(variableName == "this") {
      return environment.getCurrentInstance();
    }
    return environment.getVariable(variableName);
  }
}
