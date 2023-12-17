import 'package:json_annotation/json_annotation.dart';
/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/ast_node.dart';
import 'package:capyscript/Interpreter/interpreter_class.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';

part 'ast_class_get_node.g.dart';

@JsonSerializable(explicitToJson: true)
class ASTClassGetNode extends ASTNode {
  factory ASTClassGetNode.fromJson(Map<String, dynamic> json) =>
      _$ASTClassGetNodeFromJson(json);

  Map<String, dynamic> toJson() => _$ASTClassGetNodeToJson(this);

  final ASTNode targetExpression;
  final List<String> fieldNames;

  const ASTClassGetNode({
    required this.targetExpression,
    required this.fieldNames,
  });

  @override
  Future execute(InterpreterEnvironment environment) async {
    final obj = await targetExpression.execute(environment);
    if (obj is InterpreterClass) {
      dynamic current = await obj.properties[fieldNames.first];
      for (int i = 1; i < fieldNames.length; i++) {
        if (current is InterpreterClass) {
          current = await current.properties[fieldNames[i]];
        }
      }
      return current;
    }
    throw Exception("${obj.toString()} is undefined");
  }
}
