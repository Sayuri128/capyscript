/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'dart:io';

import 'package:args/args.dart';
import 'package:capyscript/Interpreter/interpreter.dart';

void main(List<String> args) async {
  final argsParser = ArgParser();
  argsParser.addOption('path');
  argsParser.addOption("output");

  final results = argsParser.parse(args);

  final File file = File(results['path']);

  final String input = file.readAsStringSync();

  final interpreter = Interpreter(source: input);
  interpreter.dumpAST(results["output"]);
}
