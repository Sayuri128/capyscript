import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:json_annotation/json_annotation.dart';
/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/ast_node.dart';

part 'method_call_node.g.dart';

@JsonSerializable(explicitToJson: true)
class ASTMethodCallNode extends ASTNode {
  factory ASTMethodCallNode.fromJson(Map<String, dynamic> json) =>
      _$ASTMethodCallNodeFromJson(json);

  Map<String, dynamic> toJson() => _$ASTMethodCallNodeToJson(this);

  final ASTNode variable;
  final String methodName;
  final List<ASTNode> arguments;

  const ASTMethodCallNode({
    required this.variable,
    required this.methodName,
    required this.arguments,
  });

  @override
  Future execute(Map<String, Map<String, dynamic>> memory,
      Map<String, ASTFunctionDeclarationNode> functions) async {
    final obj = await variable.execute(memory, functions);
    if (obj is List) {
      switch (methodName) {
        case "push":
          for (final arg in arguments) {
            obj.add(await arg.execute(memory, functions));
          }
          return null;
        case "pop":
          return obj.removeLast();
        case 'elementAt':
          return obj.elementAt(
              ((await arguments.first.execute(memory, functions)) as double)
                  .toInt());
        case "removeAt":
          return obj.removeAt(
              ((await arguments.first.execute(memory, functions)) as double)
                  .toInt());
        case "isEmpty":
          return obj.isEmpty;
        case "isNotEmpty":
          return obj.isNotEmpty;
      }
    } else if (obj is Map) {
      switch (methodName) {
        case "values":
          return obj.values;
        case "keys":
          return obj.keys;
        case "isEmpty":
          return obj.isEmpty;
        case "isNotEmpty":
          return obj.isNotEmpty;
        case "containsKey":
          return obj
              .containsKey(await arguments.first.execute(memory, functions));
        case "clear":
          return obj.clear();
        case "containsValue":
          return obj
              .containsValue(await arguments.first.execute(memory, functions));
        case "remove":
          return obj.remove(await arguments.first.execute(memory, functions));
      }
    }
  }
}
