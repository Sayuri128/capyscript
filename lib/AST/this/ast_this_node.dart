import 'package:capyscript/Interpreter/interpreter_class.dart';
import 'package:json_annotation/json_annotation.dart';
/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/ast_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';

part 'ast_this_node.g.dart';

@JsonSerializable(explicitToJson: true)
class ASTThisNode extends ASTNode {
  factory ASTThisNode.fromJson(Map<String, dynamic> json) =>
      _$ASTThisNodeFromJson(json);

  Map<String, dynamic> toJson() => _$ASTThisNodeToJson(this);

  final ASTNode value;
  final List<String> fields;

  @override
  Future execute(InterpreterEnvironment environment) async {
    dynamic obj = await value.execute(environment);
    if (obj is InterpreterClass) {
      dynamic value;
      for (int i = 0; i < fields.length; i++) {
        value = await obj.properties[fields[i]];
      }
      return value;
    }

    throw Exception("undefined");
  }

  const ASTThisNode({required this.value, required this.fields});
}
