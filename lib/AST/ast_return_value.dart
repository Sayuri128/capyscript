import 'package:json_annotation/json_annotation.dart';
/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/ast_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';

class ASTReturnValue extends ASTNode {
  final dynamic value;

  const ASTReturnValue({
    required this.value,
  });

  @override
  Future execute(InterpreterEnvironment environment) async {
    return value;
  }
}
