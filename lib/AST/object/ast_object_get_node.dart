import 'package:json_annotation/json_annotation.dart';
/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/ast_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';

part 'ast_object_get_node.g.dart';

@JsonSerializable(explicitToJson: true)
class ASTObjectGetNode extends ASTNode {
  factory ASTObjectGetNode.fromJson(Map<String, dynamic> json) =>
      _$ASTObjectGetNodeFromJson(json);

  Map<String, dynamic> toJson() => _$ASTObjectGetNodeToJson(this);

  final ASTNode object;
  final ASTNode key;

  ASTObjectGetNode({required this.object, required this.key});

  @override
  Future execute(InterpreterEnvironment environment) async {
    final target = (await object.execute(environment));
    final keyR = await key.execute(environment);
    return target[keyR];
  }
}
