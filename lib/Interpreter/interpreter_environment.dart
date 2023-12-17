/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/class_declaration/ast_class_declaration_node.dart';
import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/Interpreter/interpreter_class.dart';
import 'package:capyscript/Interpreter/interpreter_scoped_environment.dart';
import 'package:capyscript/Interpreter/interpreter_variable_reference.dart';

class InterpreterEnvironment {
  final Map<String, ASTClassDeclarationNode> _classes = {};
  final Map<String, ASTFunctionDeclarationNode> functions;

  InterpreterScopedEnvironment _currentScope;

  void addClass(
      {required String className, required ASTClassDeclarationNode clazz}) {
    _classes[className] = clazz;
  }

  ASTClassDeclarationNode? getClass(String className) {
    return _classes[className];
  }

  void enterScope() {
    _currentScope =
        InterpreterScopedEnvironment(parentScope: _currentScope, variables: {});
  }

  void exitScope() {
    if (_currentScope.parentScope != null) {
      _currentScope = _currentScope.parentScope!;
    }
  }

  void setCurrentInstance(InterpreterClass instance) {
    _currentScope.setCurrentInstance(instance);
  }

  void removeCurrentInstance() {
    _currentScope.removeCurrentInstance();
  }

  InterpreterClass? getCurrentInstance() {
    return _currentScope.getCurrentInstance();
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
