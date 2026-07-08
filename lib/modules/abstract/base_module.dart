/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/ast_tree.dart';
import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:capyscript/modules/converter/converter_module.dart';
import 'package:capyscript/modules/date/date_module.dart';
import 'package:capyscript/modules/html/html_module.dart';
import 'package:capyscript/modules/json/json_module.dart';
import 'package:capyscript/modules/waka_models/anime/anime_models_module.dart';
import 'package:capyscript/modules/waka_models/manga/manga_models_module.dart';
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
  dynamic getVariable(String name, InterpreterEnvironment environment,
      {dynamic defaultValue}) {
    try {
      final variable = environment.getVariable(name);
      if (variable == null && defaultValue != null) {
        return defaultValue;
      }
      return variable;
    } catch (e) {
      if (defaultValue != null) {
        return defaultValue;
      }
      throw Exception("$name not found");
    }
  }

  ASTFunctionDeclarationNode toDeclarationNode() {
    return ASTFunctionDeclarationNode(
        functionName: "", body: this, parameters: []);
  }
}

typedef ModuleFactory = BaseModule Function();

final Map<String, ModuleFactory> moduleFactories = {
  HttpModule.module_name: HttpModule.new,
  IOModule.module_name: IOModule.new,
  JsonModule.module_name: JsonModule.new,
  ConverterModule.module_name: ConverterModule.new,
  DateModule.module_name: DateModule.new,
  HtmlModule.module_name: HtmlModule.new,
  AnimeModelsModule.module_name: AnimeModelsModule.new,
  MangaModelsModule.module_name: MangaModelsModule.new,
};
