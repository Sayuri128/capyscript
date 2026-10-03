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
import 'package:capyscript/Interpreter/capyscript_runtime_error.dart';
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
      final args = [];
      for (final argument in arguments) {
        args.add(await argument.execute(environment));
      }
      return await closure.call(environment, args);
    }

    final ASTFunctionDeclarationNode? resolved = environment.functions[functionKey];
    if (resolved == null) {
      throw Exception("function $functionKey not found");
    }
    final ASTFunctionDeclarationNode functionDec = resolved;

    final boundArguments = await _resolveArguments(functionDec, environment);
    final callEnvironment = environment.functionEnvironment();

    try {
      for (int i = 0; i < functionDec.parameters.length; i++) {
        final param = functionDec.parameters[i];
        final paramName = param.paramName;
        if (boundArguments.containsKey(paramName)) {
          callEnvironment.defineVariable(paramName, boundArguments[paramName]);
        } else if (param.isOptional && param.defaultValue != null) {
          callEnvironment.defineVariable(
              paramName, await param.defaultValue!.execute(callEnvironment));
        } else {
          throw Exception(
              "argument ${i + 1} ($paramName) is not defined in function ${functionDec.functionName}");
        }
        if (param.paramType != null) {
          TypeChecker.check(param.paramType!,
              callEnvironment.getVariable(paramName), callEnvironment);
        }
      }

      late final dynamic res;

      try {
        res = await functionDec.execute(callEnvironment);
      } on ASTReturnValue catch (r) {
        res = await r.execute(callEnvironment);
      }

      if (functionDec.returnType != null && functionDec.returnType != 'void') {
        TypeChecker.check(functionDec.returnType!, res, callEnvironment);
      }

      return res;
    } catch (e, st) {
      CapyScriptRuntimeError.rethrowWithFrame(e, st, functionDec.functionName);
    }
  }

  Future<Map<String, dynamic>> _resolveArguments(
      ASTFunctionDeclarationNode functionDec,
      InterpreterEnvironment environment) async {
    final first = arguments.isEmpty ? null : arguments.first;
    final namedKeys = <dynamic>[];
    if (first is ASTMapNode) {
      for (final key in first.keys) {
        namedKeys.add(key is ASTVariableNode
            ? await key.executeOrName(environment)
            : await key.execute(environment));
      }
    }

    final bound = <String, dynamic>{};
    for (int i = 0; i < functionDec.parameters.length; i++) {
      final paramName = functionDec.parameters[i].paramName;
      final namedIndex = namedKeys.indexOf(paramName);
      if (namedIndex != -1) {
        bound[paramName] =
            await (first as ASTMapNode).values[namedIndex].execute(environment);
      } else if (i < arguments.length) {
        bound[paramName] = await arguments[i].execute(environment);
      }
    }
    return bound;
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
