/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'dart:io';

import 'package:capyscript/Interpreter/interpreter.dart';
import 'package:capyscript/Lexer/lexer.dart';

void main() async {
  final File file = File("../main.capyscript");
  final String input = file.readAsStringSync();

  final interpreter = Interpreter(source: input);
  print(await interpreter.interpret());
  // final lexer = Lexer(source: input);
  //
  // final tokens = [];

  // var token = lexer.getNextToken();
  // while(tokens.length != input.length) {
  //   tokens.add(token);
  //   token = lexer.getNextToken();
  // }
  // print(tokens.length);
  // interpreter.dumpAST("../AST.capyast");
}
