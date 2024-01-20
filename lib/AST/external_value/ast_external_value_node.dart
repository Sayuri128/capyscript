import 'package:json_annotation/json_annotation.dart';
/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/ast_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';

part 'ast_external_value_node.g.dart';

@JsonSerializable(explicitToJson: true)
class ASTExternalValueNode extends ASTNode {
  factory ASTExternalValueNode.fromJson(Map<String, dynamic> json) =>
      _$ASTExternalValueNodeFromJson(json);
  Map<String, dynamic> toJson() => _$ASTExternalValueNodeToJson(this);

  final dynamic value;

  ASTExternalValueNode({required this.value});

  @override
  Future execute(InterpreterEnvironment environment) async {
    return value;
  }
}
