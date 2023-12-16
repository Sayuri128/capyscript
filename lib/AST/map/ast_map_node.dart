import 'package:json_annotation/json_annotation.dart';
/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/ast_node.dart';
import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';

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

  @override
  Future execute(Map<String, Map<String, dynamic>> memory,
      Map<String, ASTFunctionDeclarationNode> functions) async {
    final Map<dynamic, dynamic> map = {};
    for (int i = 0; i < keys.length; i++) {
      map[await keys[i].execute(memory, functions)] =
          await values[i].execute(memory, functions);
    }
    return map;
  }
}
