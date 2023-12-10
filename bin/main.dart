/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'dart:convert';
import 'dart:io';

import 'package:capyscript/AST/ast_node.dart';
import 'package:capyscript/Parser/parser.dart';


void main() {
  final File file = File("../main.capyscript");
  final String input = file.readAsStringSync();

  final Parser parser = Parser(source: input);

  final functions = parser.parse();

  print("functions number: ${functions.length}");
  dumpAST(functions);
}

void dumpAST(List<ASTNode> nodes) {
  final arr = [];
  for (var value in nodes) {
    arr.add(value.toJson());
  }
  final File output = File("../AST.capyast");
  final jsonEncoder = JsonEncoder.withIndent(" ");
  output.writeAsBytesSync(utf8.encode(jsonEncoder.convert(arr)));
}
