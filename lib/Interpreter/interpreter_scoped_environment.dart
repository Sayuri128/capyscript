/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/Interpreter/interpreter_class.dart';
import 'package:capyscript/Interpreter/interpreter_variable_reference.dart';

class InterpreterScopedEnvironment {
  final Map<String, InterpreterVariableReference> variables;
  final InterpreterScopedEnvironment? parentScope;
  InterpreterClass? _currentInstance;

  InterpreterScopedEnvironment({
    required this.variables,
    this.parentScope,
  });

  void setCurrentInstance(InterpreterClass instance) {
    _currentInstance = instance;
  }

  void removeCurrentInstance() {
    _currentInstance = null;
  }

  InterpreterClass? getCurrentInstance({int level = 0}) {
    return _currentInstance ??
        (level < 1 ? parentScope?.getCurrentInstance(level: level + 1) : null);
  }

  void setVariable<T>(String name, T value) {
    variables[name] = InterpreterVariableReference(value);
  }

  T getVariable<T>(String name, {int level = 0}) {
    final reference = variables[name];
    if (reference != null) {
      return reference.value;
    } else if (parentScope != null && level < 1) {
      return parentScope!.getVariable(name, level: level + 1);
    }

    throw Exception("Variable $name not found.");
  }
}
