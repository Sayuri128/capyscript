/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'dart:convert';
import 'dart:io';

import 'package:capyscript/AST/ast_result.dart';
import 'package:capyscript/AST/function_call/ast_function_call_node.dart';
import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/Parser/parser.dart';

class Interpreter {
  late final Parser parser;

  final Map<String, Map<String, dynamic>> _memory = {};
  final Map<String, ASTFunctionDeclarationNode> _functions = {};

  Interpreter({required String source}) {
    this.parser = Parser(source: source);
  }

  Future<dynamic> interpret() async {
    final tree = parser.parse();
    print("functions number: ${tree.functions.length}");

    for (final function in tree.functions) {
      _functions[function.functionName] = function;
    }

    final mainCall = ASTFunctionCallNode(functionName: "main", arguments: []);
    return await mainCall.execute(_memory, _functions);
  }

  void dumpAST(String path) {
    final File output = File(path);
    output.writeAsBytesSync(utf8.encode(_dumpAST(parser.parse())));
  }

  dynamic _dumpAST(ASTResult nodes) {
    final jsonEncoder = JsonEncoder.withIndent(" ");
    return jsonEncoder.convert(nodes.toJson());
  }
}
