/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/ast_return_value.dart';
import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/AST/map/ast_map_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:json_annotation/json_annotation.dart';
import '../ast_node.dart';

part 'ast_function_call_node.g.dart';

@JsonSerializable(explicitToJson: true)
class ASTFunctionCallNode extends ASTNode {
  factory ASTFunctionCallNode.fromJson(Map<String, dynamic> json) =>
      _$ASTFunctionCallNodeFromJson(json);

  Map<String, dynamic> toJson() => _$ASTFunctionCallNodeToJson(this);
  final ASTNode function;
  final List<ASTNode> arguments;

  const ASTFunctionCallNode({
    required this.function,
    required this.arguments,
  });

  @override
  Future<dynamic> execute(InterpreterEnvironment environment) async {
    late final ASTFunctionDeclarationNode functionDec;

    try {
      functionDec = environment.functions[await function.execute(environment)]!;
    } catch (e) {
      throw Exception("function ${function.toString()} not found");
    }

    environment.enterScope();

    for (int i = 0; i < functionDec.parameters.length; i++) {
      final arg = arguments[0];
      final paramName = functionDec.parameters[i].paramName;
      bool foundInMap = false;
      if (arg is ASTMapNode) {
        for (int j = 0; j < arg.keys.length; j++) {
          final key = await arg.keys[j];
          final keyValue = await key.execute(environment);
          if (keyValue == paramName) {
            environment.setVariable(
                paramName, await arg.values[j].execute(environment));
            foundInMap = true;
            break;
          }
        }
      }
      if (!foundInMap) {
        try {
          environment.setVariable(functionDec.parameters[i].paramName,
              await arguments[i].execute(environment));
        } catch (e) {
          throw Exception(
              "argument ${i + 1} is not defined - ${arguments.toString()} ${paramName}");
        }
      }
    }

    late final dynamic res;

    try {
      res = await functionDec.execute(environment);
    } on ASTReturnValue catch (r) {
      res = await r.execute(environment);
    }

    environment.exitScope();
    return res;
  }
}
