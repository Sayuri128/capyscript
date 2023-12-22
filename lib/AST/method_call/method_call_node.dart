/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:capyscript/modules/abstract/external_object.dart';
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
  Future execute(InterpreterEnvironment environment) async {
    final obj = await variable.execute(environment);
    if (obj is List) {
      switch (methodName) {
        case "push":
          for (final arg in arguments) {
            obj.add(await arg.execute(environment));
          }
          return null;
        case "pop":
          return obj.removeLast();
        case 'elementAt':
          return obj.elementAt(
              ((await arguments.first.execute(environment)) as num).toInt());
        case "removeAt":
          return obj.removeAt(
              ((await arguments.first.execute(environment)) as num).toInt());
      }
    } else if (obj is Map) {
      switch (methodName) {
        case "containsKey":
          return obj.containsKey(await arguments.first.execute(environment));
        case "clear":
          return obj.clear();
        case "containsValue":
          return obj.containsValue(await arguments.first.execute(environment));
        case "remove":
          return obj.remove(await arguments.first.execute(environment));
      }
    }

    if (obj is String) {
      switch (methodName) {
        case "contains":
          return obj.contains(await arguments.first.execute(environment));
        case "split":
          return obj.split(await arguments.first.execute(environment));
        case "replaceAll":
          return obj.replaceAll(await arguments.first.execute(environment),
              await arguments[1].execute(environment));
        case "replaceFirst":
          return obj.replaceFirst(await arguments.first.execute(environment),
              await arguments[1].execute(environment));
        case "trim":
          return obj.trim();
        case "trimLeft":
          return obj.trimLeft();
        case "trimRight":
          return obj.trimRight();
        case "toLowerCase":
          return obj.toLowerCase();
        case "toUpperCase":
          return obj.toUpperCase();
        case "substring":
          return obj.substring(
              ((await arguments.first.execute(environment)) as num).toInt(),
              ((await arguments[1].execute(environment)) as num).toInt());
      }
    }

    if (obj is ExternalObject) {
      return obj.callFunction(methodName,
          ordinalArguments: (await Future.wait(
                  arguments.map((e) async => await e.execute(environment))))
              .toList());
    }
  }
}
