import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:json_annotation/json_annotation.dart';
/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/ast_node.dart';

part 'ast_array_node.g.dart';

@JsonSerializable(explicitToJson: true)
class ASTArrayNode extends ASTNode {
  factory ASTArrayNode.fromJson(Map<String, dynamic> json) =>
      _$ASTArrayNodeFromJson(json);

  Map<String, dynamic> toJson() => _$ASTArrayNodeToJson(this);

  final List<ASTNode> expressions;

  const ASTArrayNode({required this.expressions});

  factory ASTArrayNode.fromList(List<dynamic> list) {
    final List<ASTNode> expressions = [];
    list.forEach((element) {
      expressions.add(ASTNode.fromValue(element));
    });
    return ASTArrayNode(expressions: expressions);
  }

  @override
  Future execute(InterpreterEnvironment environment) async {
    return (await Future.wait(expressions.map((e) => e.execute(environment))))
        .toList();
  }
}
