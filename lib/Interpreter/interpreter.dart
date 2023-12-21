/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'dart:convert';
import 'dart:io';

import 'package:capyscript/AST/ast_tree.dart';
import 'package:capyscript/AST/function_call/ast_function_call_node.dart';
import 'package:capyscript/AST/import/ast_import_node.dart';
import 'package:capyscript/AST/string/ast_string_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:capyscript/Interpreter/interpreter_tree.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/abstract/imported/imported_module.dart';
import 'package:capyscript/parser/parser.dart';
import 'package:path/path.dart' as path;

class Interpreter {
  late final Parser parser;

  late final File _mainFile;

  late final InterpreterEnvironment _environment;

  Interpreter({required String mainPath}) {
    _mainFile = File(mainPath);
    final String input = _mainFile.readAsStringSync();

    _environment = InterpreterEnvironment(functions: {});

    this.parser = Parser(source: input);
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
    final tree = parser.parse();
    print("functions number: ${tree.functions.length}");

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
    return imports.map((import) {
      final module = modules[import.moduleName];
      if (module == null) {
        final moduleFilePath =
            '${path.join(path.dirname(path.normalize(_mainFile.absolute.path)), import.moduleName)}';

        final file = File(moduleFilePath);

        if (!file.existsSync()) {
          throw Exception("Module ${import.moduleName} not found");
        }

        final moduleParser = Parser(source: file.readAsStringSync());
        return ImportedModule(
            body: moduleParser.parse(), moduleName: import.moduleName);
      }

      return module;
    }).toList();
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
