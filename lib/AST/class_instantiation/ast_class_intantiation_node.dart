import 'package:json_annotation/json_annotation.dart';
/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/ast_node.dart';
import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/Interpreter/interpreter_class.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';

part 'ast_class_intantiation_node.g.dart';

@JsonSerializable(explicitToJson: true)
class ASTClassInstantiationNode extends ASTNode {
  factory ASTClassInstantiationNode.fromJson(Map<String, dynamic> json) =>
      _$ASTClassInstantiationNodeFromJson(json);

  Map<String, dynamic> toJson() => _$ASTClassInstantiationNodeToJson(this);
  final String className;
  final List<ASTNode> arguments;
  final String functionName;

  const ASTClassInstantiationNode(
      {required this.className,
      required this.arguments,
      required this.functionName});

  @override
  Future execute(InterpreterEnvironment environment) async {
    final clazz = environment.getClass(className);
    if (clazz == null) {
      throw Exception("Unknown class ${className}");
    }

    final Map<String, Future<dynamic> Function()> methods = {};
    final Map<String, dynamic> properties = {};

    for (final method in clazz.methods.entries) {
      methods[method.key] = () async => await method.value.execute(environment);
    }

    for (final property in clazz.properties.entries) {
      properties[property.key] = property.value.execute(environment);
    }

    return InterpreterClass(
        className: className,
        methods: methods,
        properties: properties,
        environment: environment);
  }
}
