/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'dart:io';

import 'package:capyscript/Interpreter/interpreter.dart';

void main() async {
  final File file = File("../main.capyscript");
  final String input = file.readAsStringSync();

  final interpreter = Interpreter(source: input);
  print(await interpreter.interpret());

  // interpreter.dumpAST("../AST.capyast");
}
