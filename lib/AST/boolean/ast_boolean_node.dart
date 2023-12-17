/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/ast_node.dart';
import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';

class ASTBooleanNode extends ASTNode {
  final bool value;

  const ASTBooleanNode({
    required this.value,
  });

  @override
  Future execute(InterpreterEnvironment environment) async {
    return value;
  }
}
