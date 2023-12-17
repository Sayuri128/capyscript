/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/Interpreter/interpreter_environment.dart';

class InterpreterClass {
  final String className;
  final Map<String, Future<dynamic> Function()> methods;
  final Map<String, dynamic> properties;
  final InterpreterEnvironment environment;

  const InterpreterClass({
    required this.className,
    required this.methods,
    required this.properties,
    required this.environment
  });

  @override
  String toString() {
    return 'InterpreterClass{className: $className, methods: $methods, properties: $properties}';
  }
}
