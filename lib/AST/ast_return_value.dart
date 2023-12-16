/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/ast_node.dart';
import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';

class ASTReturnValue<T> extends ASTNode {
  final T value;

  const ASTReturnValue({
    required this.value,
  });

  @override
  Future execute(Map<String, Map<String, dynamic>> memory,
      Map<String, ASTFunctionDeclarationNode> functions) async {
    return value;
  }
}
