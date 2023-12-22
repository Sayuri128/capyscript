import 'package:capyscript/AST/ast_reference.dart';
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
    try {
      return environment.getVariable(variableName);
    } catch (e) {
      return variableName;
    }
  }

  @override
  ASTReference getReference() {
    return ASTReference(getter: (InterpreterEnvironment environment) async {
      return this.execute(environment);
    }, setter: (InterpreterEnvironment environment, dynamic value) async {
      try {
        return environment.setVariable(variableName, value);
      } catch (e) {
        return;
      }
    });
  }

  @override
  String toString() {
    return 'ASTVariableNode{functionName: $functionName, variableName: $variableName}';
  }
}
