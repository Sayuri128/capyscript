/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */


import 'package:args/args.dart';
import 'package:capyscript/Interpreter/interpreter.dart';

void main(List<String> args) async {
  final argsParser = ArgParser();
  argsParser.addOption('path');

  final results = argsParser.parse(args);


  final interpreter = Interpreter(mainPath: results['path']);
  print(await interpreter.interpret());
}
