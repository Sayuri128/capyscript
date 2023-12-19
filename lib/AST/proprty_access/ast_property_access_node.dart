import 'package:capyscript/AST/ast_reference.dart';
import 'package:json_annotation/json_annotation.dart';
/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/ast_node.dart';
import 'package:capyscript/Interpreter/interpreter_class.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';

part 'ast_property_access_node.g.dart';

@JsonSerializable(explicitToJson: true)
class ASTPropertyAccessNode extends ASTNode {
  factory ASTPropertyAccessNode.fromJson(Map<String, dynamic> json) =>
      _$ASTPropertyAccessNodeFromJson(json);

  Map<String, dynamic> toJson() => _$ASTPropertyAccessNodeToJson(this);

  final ASTNode targetExpression;
  final String fieldName;

  const ASTPropertyAccessNode({
    required this.targetExpression,
    required this.fieldName,
  });

  @override
  Future execute(InterpreterEnvironment environment) async {
    final obj = await targetExpression.execute(environment);
    if (obj is InterpreterClass) {
      return await obj.properties[fieldName];
    }
    throw Exception("${obj.toString()} is undefined");
  }

  @override
  ASTReference getReference() {
    return ASTReference(getter: (InterpreterEnvironment environment) async {
      return this.execute(environment);
    }, setter: (InterpreterEnvironment environment, dynamic value) async {
      final obj = await targetExpression.execute(environment);
      if (obj is InterpreterClass) {
        obj.properties[fieldName] = value;
        return;
      }
      throw Exception("${obj.toString()} is undefined");
    });
  }
}
