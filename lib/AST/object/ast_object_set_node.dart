import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:json_annotation/json_annotation.dart';

/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/ast_node.dart';

part 'ast_object_set_node.g.dart';

@JsonSerializable(explicitToJson: true)
class ASTObjectSetNode extends ASTNode {
  factory ASTObjectSetNode.fromJson(Map<String, dynamic> json) =>
      _$ASTObjectSetNodeFromJson(json);

  Map<String, dynamic> toJson() => _$ASTObjectSetNodeToJson(this);

  final ASTNode targetExpression;
  final List<ASTNode> keyExpressions;
  final ASTNode valueExpression;

  const ASTObjectSetNode({
    required this.targetExpression,
    required this.keyExpressions,
    required this.valueExpression,
  });

  @override
  Future execute(InterpreterEnvironment environment) async {
    dynamic target = await targetExpression.execute(environment);
    dynamic key;

    final value = await valueExpression.execute(environment);

    for (final keyExp in keyExpressions) {
      if (keyExp == keyExpressions.last) {
        break;
      }
      key = await keyExp.execute(environment);
      target = target[key];
    }

    target[key] = value;
    return null;
  }
}
