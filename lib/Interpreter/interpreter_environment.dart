/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/Interpreter/interpreter_scoped_environment.dart';

class InterpreterEnvironment {
  final Map<String, ASTFunctionDeclarationNode> functions;

  InterpreterScopedEnvironment _currentScope;

  void enterScope() {
    _currentScope =
        InterpreterScopedEnvironment(parentScope: _currentScope, variables: {});
  }

  void exitScope() {
    if (_currentScope.parentScope != null) {
      _currentScope = _currentScope.parentScope!;
    }
  }

  void setVariable(String name, dynamic value) {
    _currentScope.setVariable(name, value);
  }

  dynamic getVariable(String name) {
    return _currentScope.getVariable(name);
  }

  InterpreterEnvironment({
    required this.functions,
  }) : _currentScope = InterpreterScopedEnvironment(variables: {});
}
