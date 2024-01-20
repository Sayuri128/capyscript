/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:args/args.dart';
import 'package:capyscript/Interpreter/interpreter.dart';

void main(List<String> args) async {
  final argsParser = ArgParser();
  argsParser.addOption('path');
  argsParser.addOption("output");

  final results = argsParser.parse(args);

  final interpreter = Interpreter.fromFile(path: results['path']);
  interpreter.dumpAST(results["output"]);
}
