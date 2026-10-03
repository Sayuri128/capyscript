/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/class/ast_class_declaration_node.dart';
import 'package:capyscript/AST/class/ast_interface_declaration_node.dart';
import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/Interpreter/interpreter_scoped_environment.dart';

class InterpreterEnvironment {
  final Map<String, ASTFunctionDeclarationNode> functions;
  final Map<String, ASTClassDeclarationNode> classes;
  final Map<String, ASTInterfaceDeclarationNode> interfaces;

  void registerClass(ASTClassDeclarationNode cls) => classes[cls.className] = cls;
  void registerInterface(ASTInterfaceDeclarationNode iface) =>
      interfaces[iface.interfaceName] = iface;
  ASTClassDeclarationNode lookupClass(String name) => classes[name]!;

  final InterpreterScopedEnvironment rootScope;
  final InterpreterScopedEnvironment _currentScope;

  InterpreterScopedEnvironment get currentScope => _currentScope;

  InterpreterEnvironment functionEnvironment() => _fork(
      InterpreterScopedEnvironment(
          parentScope: rootScope, variables: {}, isFunctionScope: true));

  InterpreterEnvironment closureEnvironment(
          InterpreterScopedEnvironment capturedScope) =>
      _fork(InterpreterScopedEnvironment(
          parentScope: capturedScope, variables: {}));

  InterpreterEnvironment _fork(InterpreterScopedEnvironment scope) =>
      InterpreterEnvironment._(
        functions: functions,
        classes: classes,
        interfaces: interfaces,
        rootScope: rootScope,
        currentScope: scope,
      );

  void defineVariable(String name, dynamic value) {
    _currentScope.defineVariable(name, value);
  }

  void setVariable(String name, dynamic value) {
    _currentScope.setVariable(name, value);
  }

  dynamic getVariable(String name) {
    return _currentScope.getVariable(name);
  }

  InterpreterEnvironment._({
    required this.functions,
    required this.classes,
    required this.interfaces,
    required this.rootScope,
    required InterpreterScopedEnvironment currentScope,
  }) : _currentScope = currentScope;

  factory InterpreterEnvironment({
    required Map<String, ASTFunctionDeclarationNode> functions,
  }) {
    final root = InterpreterScopedEnvironment(variables: {});
    return InterpreterEnvironment._(
      functions: functions,
      classes: {},
      interfaces: {},
      rootScope: root,
      currentScope: root,
    );
  }
}
