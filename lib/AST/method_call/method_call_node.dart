/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/class/ast_instance_node.dart';
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
    final args = await Future.wait(
        arguments.map((e) async => await e.execute(environment)));

    if (obj is List) {
      switch (methodName) {
        case "push":
        case "add":
          obj.addAll(args);
          return null;
        case "pop":
          return obj.removeLast();
        case 'elementAt':
          return obj.elementAt((args.first as num).toInt());
        case "removeAt":
          return obj.removeAt((args.first as num).toInt());
        case "remove":
          return obj.remove(args.first);
        case "insert":
          obj.insert((args.first as num).toInt(), args[1]);
          return null;
        case "indexOf":
          return obj.indexOf(args.first);
        case "contains":
          return obj.contains(args.first);
        case "join":
          return obj.join(args.isEmpty ? "" : args.first.toString());
        case "sublist":
          return obj.sublist((args.first as num).toInt(),
              args.length > 1 ? (args[1] as num).toInt() : null);
        case "reversed":
          return obj.reversed.toList();
        case "sort":
          obj.sort();
          return obj;
        case "clear":
          obj.clear();
          return null;
      }
    } else if (obj is Map) {
      switch (methodName) {
        case "containsKey":
          return obj.containsKey(args.first);
        case "clear":
          return obj.clear();
        case "containsValue":
          return obj.containsValue(args.first);
        case "remove":
          return obj.remove(args.first);
        case "addAll":
          return obj.addAll(args.first);
      }
    } else if (obj is String) {
      switch (methodName) {
        case "contains":
          return obj.contains(args.first);
        case "split":
          return obj.split(args.first);
        case "replaceAll":
          return obj.replaceAll(args.first, args[1]);
        case "replaceFirst":
          return obj.replaceFirst(args.first, args[1]);
        case "startsWith":
          return obj.startsWith(args.first);
        case "endsWith":
          return obj.endsWith(args.first);
        case "indexOf":
          return obj.indexOf(args.first);
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
        case "padLeft":
          return obj.padLeft((args.first as num).toInt(),
              args.length > 1 ? args[1].toString() : ' ');
        case "padRight":
          return obj.padRight((args.first as num).toInt(),
              args.length > 1 ? args[1].toString() : ' ');
        case "substring":
          return obj.substring((args.first as num).toInt(),
              args.length > 1 ? (args[1] as num).toInt() : null);
      }
    }

    if (obj is ASTInstanceNode) {
      return await obj.callMethod(methodName, args, environment);
    }

    if (obj is ExternalObject) {
      return obj.callFunction(methodName, ordinalArguments: args);
    }

    throw Exception(
        "method '$methodName' is not supported on ${obj == null ? 'null' : obj.runtimeType}");
  }
}
