/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'dart:convert';
import 'dart:io';

import 'package:capyscript/AST/ast_tree.dart';
import 'package:capyscript/AST/function_call/ast_function_call_node.dart';
import 'package:capyscript/AST/import/ast_import_node.dart';
import 'package:capyscript/AST/map/ast_map_node.dart';
import 'package:capyscript/AST/string/ast_string_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:capyscript/Interpreter/interpreter_tree.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/abstract/imported/imported_module.dart';
import 'package:capyscript/parser/parser.dart';
import 'package:path/path.dart' as path;

class Interpreter {
  late final Parser parser;

  final File? mainFile;

  late final InterpreterEnvironment _environment;

  Interpreter({required String data, this.mainFile}) {
    _environment = InterpreterEnvironment(functions: {});
    this.parser = Parser(source: data);
  }

  factory Interpreter.fromFile({required String path}) {
    final file = File(path);
    final String input = file.readAsStringSync();

    return Interpreter(data: input, mainFile: file);
  }

  InterpreterTree? _interpreterTree;

  Future<dynamic> runFunction(String functionName,
      {Map<String, dynamic>? arguments}) async {
    InterpreterTree interpreterResult = _runParser();

    try {
      interpreterResult.astTree.functions
          .firstWhere((element) => element.functionName == functionName);
    } catch (e) {
      throw Exception("function $functionName not found");
    }

    final functionCall = ASTFunctionCallNode(
        function: ASTStringNode(value: functionName),
        arguments: [if (arguments != null) ASTMapNode.fromMap(arguments)]);

    return await functionCall.execute(_environment);
  }

  Future<dynamic> interpret() async {
    InterpreterTree interpreterResult = _runParser();

    try {
      interpreterResult.astTree.functions
          .firstWhere((element) => element.functionName == "main");
    } catch (e) {
      throw Exception("main function not found");
    }

    final mainCall = ASTFunctionCallNode(
        function: ASTStringNode(value: 'main'), arguments: []);
    return await mainCall.execute(_environment);
  }

  InterpreterTree _runParser() {
    if (_interpreterTree != null) {
      return _interpreterTree!;
    }

    final tree = parser.parse();

    final modules = _loadModules(imports: tree.modules);

    for (final module in modules) {
      _importModule(module.body);
    }
    _importModule(tree);
    return InterpreterTree(astTree: tree, parsedModules: modules);
  }

  void _importModule(ASTTree result) {
    for (final function in result.functions) {
      _environment.functions[function.functionName] = function;
    }
  }

  List<BaseModule> _loadModules({required List<ASTImportNode> imports}) {
    return imports
        .map((import) {
          final module = modules[import.moduleName];
          if (module == null && mainFile != null) {
            final moduleFilePath =
                '${path.join(path.dirname(path.normalize(mainFile!.absolute.path)), import.moduleName)}';

            final file = File(moduleFilePath);

            if (!file.existsSync()) {
              throw Exception("Module ${import.moduleName} not found");
            }

            final moduleParser = Parser(source: file.readAsStringSync());
            return ImportedModule(
                body: moduleParser.parse(), moduleName: import.moduleName);
          }

          return module;
        })
        .where((element) => element != null)
        .cast<BaseModule>()
        .toList();
  }

  void dumpAST(String path) {
    final File output = File(path);
    output.writeAsBytesSync(utf8.encode(_dumpAST(_runParser())));
  }

  dynamic _dumpAST(InterpreterTree result) {
    final jsonEncoder = JsonEncoder.withIndent(" ");
    return jsonEncoder.convert(result.toJson());
  }
}
