/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/ast_tree.dart';
import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:capyscript/modules/converter/converter_module.dart';
import 'package:capyscript/modules/date/date_module.dart';
import 'package:capyscript/modules/json/json_module.dart';
import 'package:json_annotation/json_annotation.dart';
/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/ast_node.dart';
import 'package:capyscript/modules/http/http_module.dart';
import 'package:capyscript/modules/io/io_module.dart';

part 'base_module.g.dart';

@JsonSerializable(explicitToJson: true)
class BaseModule {
  factory BaseModule.fromJson(Map<String, dynamic> json) =>
      _$BaseModuleFromJson(json);

  Map<String, dynamic> toJson() => _$BaseModuleToJson(this);

  final String moduleName;
  late final ASTTree body;

  BaseModule({required this.moduleName}) {}
}

class ModuleFunctionBody extends ASTNode {
  dynamic getVariable(String name, InterpreterEnvironment environment) {
    try {
      return environment.getVariable(name);
    } catch (e) {
      throw Exception("$name not found");
    }
  }

  ASTFunctionDeclarationNode toDeclarationNode() {
    return ASTFunctionDeclarationNode(
        functionName: "", body: this, parameters: []);
  }
}

final Map<String, BaseModule> modules = {
  HttpModule.module_name: HttpModule(),
  IOModule.module_name: IOModule(),
  JsonModule.module_name: JsonModule(),
  ConverterModule.module_name: ConverterModule(),
  DateModule.module_name: DateModule(),
};
