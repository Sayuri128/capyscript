/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/Interpreter/interpreter_environment.dart';

class ASTReference {
  final Future<dynamic> Function(InterpreterEnvironment environment) getter;
  final Future<void> Function(InterpreterEnvironment environment, dynamic value)
      setter;

  ASTReference({
    required this.getter,
    required this.setter,
  });

  factory ASTReference.empty() {
    return ASTReference(
      getter: (_) async => null,
      setter: (_, __) async {},
    );
  }
}
