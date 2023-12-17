import 'package:capyscript/AST/method_declaration/ast_method_declrataion_node.dart';
import 'package:capyscript/AST/property/ast_property_node.dart';
import 'package:capyscript/Interpreter/interpreter_class.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:json_annotation/json_annotation.dart';
/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/ast_node.dart';
import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';

part 'ast_class_declaration_node.g.dart';

@JsonSerializable(explicitToJson: true)
class ASTClassDeclarationNode extends ASTNode {
  factory ASTClassDeclarationNode.fromJson(Map<String, dynamic> json) =>
      _$ASTClassDeclarationNodeFromJson(json);

  Map<String, dynamic> toJson() => _$ASTClassDeclarationNodeToJson(this);

  final String className;
  final Map<String, ASTMethodDeclarationNode> methods;
  final Map<String, ASTPropertyNode> properties;

  const ASTClassDeclarationNode({
    required this.className,
    required this.methods,
    required this.properties,
  });

  @override
  Future execute(InterpreterEnvironment environment) async {
    return null;
  }
}
