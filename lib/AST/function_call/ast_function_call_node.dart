/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/ast_return_value.dart';
import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/AST/lambda/ast_closure.dart';
import 'package:capyscript/AST/map/ast_map_node.dart';
import 'package:capyscript/AST/string/ast_string_node.dart';
import 'package:capyscript/AST/variable_node/ast_variable_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:capyscript/Interpreter/type_checker.dart';
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
    final dynamic functionKey;
    ASTClosure? closure;
    if (function is ASTVariableNode) {
      final name = (function as ASTVariableNode).variableName;
      functionKey = name;
      if (!environment.functions.containsKey(name)) {
        closure = _tryResolveClosure(environment, name);
      }
    } else if (function is ASTStringNode) {
      functionKey = (function as ASTStringNode).value;
    } else {
      final value = await function.execute(environment);
      if (value is ASTClosure) {
        closure = value;
      }
      functionKey = value;
    }

    if (closure != null) {
      final args = await Future.wait(
          arguments.map((a) async => await a.execute(environment)));
      return await closure.call(environment, args);
    }

    final ASTFunctionDeclarationNode? resolved = environment.functions[functionKey];
    if (resolved == null) {
      throw Exception("function $functionKey not found");
    }
    final ASTFunctionDeclarationNode functionDec = resolved;

    environment.enterScope();

    try {
      for (int i = 0; i < functionDec.parameters.length; i++) {
        final arg = arguments[0];
        final param = functionDec.parameters[i];
        final paramName = param.paramName;
        bool foundInMap = false;
        if (arg is ASTMapNode) {
          for (int j = 0; j < arg.keys.length; j++) {
            final key = arg.keys[j];
            final keyValue = key is ASTVariableNode
                ? await key.executeOrName(environment)
                : await key.execute(environment);
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
            if (param.isOptional && param.defaultValue != null) {
              environment.setVariable(functionDec.parameters[i].paramName,
                  await param.defaultValue!.execute(environment));
              continue;
            }
            throw Exception(
                "argument ${i + 1} is not defined - ${arguments.toString()} ${paramName} \n in function ${functionDec.functionName}");
          }
        }
        if (param.paramType != null) {
          TypeChecker.check(
              param.paramType!, environment.getVariable(paramName), environment);
        }
      }

      late final dynamic res;

      try {
        res = await functionDec.execute(environment);
      } on ASTReturnValue catch (r) {
        res = await r.execute(environment);
      }

      if (functionDec.returnType != null && functionDec.returnType != 'void') {
        TypeChecker.check(functionDec.returnType!, res, environment);
      }

      return res;
    } finally {
      environment.exitScope();
    }
  }

  ASTClosure? _tryResolveClosure(
      InterpreterEnvironment environment, String name) {
    try {
      final value = environment.getVariable(name);
      return value is ASTClosure ? value : null;
    } catch (e) {
      return null;
    }
  }
}
