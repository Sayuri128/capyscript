import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:json_annotation/json_annotation.dart';
/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/ast_node.dart';

part 'ast_map_node.g.dart';

@JsonSerializable(explicitToJson: true)
class ASTMapNode extends ASTNode {
  factory ASTMapNode.fromJson(Map<String, dynamic> json) =>
      _$ASTMapNodeFromJson(json);

  Map<String, dynamic> toJson() => _$ASTMapNodeToJson(this);
  final List<ASTNode> keys;
  final List<ASTNode> values;

  const ASTMapNode({
    required this.keys,
    required this.values,
  });

  factory ASTMapNode.fromMap(Map<dynamic, dynamic> map) {
    final List<ASTNode> keys = [];
    final List<ASTNode> values = [];

    map.forEach((key, value) {
      keys.add(ASTNode.fromValue(key));
      values.add(ASTNode.fromValue(value));
    });

    return ASTMapNode(keys: keys, values: values);
  }

  @override
  Future execute(InterpreterEnvironment environment) async {
    final Map<dynamic, dynamic> map = {};
    for (int i = 0; i < keys.length; i++) {
      map[await keys[i].execute(environment)] =
          await values[i].execute(environment);
    }
    return map;
  }
}
