/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/Interpreter/interpreter_variable_reference.dart';

class InterpreterScopedEnvironment {
  final Map<String, InterpreterVariableReference> variables;
  final InterpreterScopedEnvironment? parentScope;

  InterpreterScopedEnvironment({
    required this.variables,
    this.parentScope,
  });

  void setVariable<T>(String name, T value) {
    variables[name] = InterpreterVariableReference(value);
  }

  T getVariable<T>(String name, {int level = 0}) {
    final reference = variables[name];
    if (reference != null) {
      return reference.value;
    } else if (parentScope != null) {
      return parentScope!.getVariable(name, level: level + 1);
    }

    throw Exception("Variable $name not found.");
  }
}
