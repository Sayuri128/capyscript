/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/ast_tree.dart';
import 'package:capyscript/api_clients/host/extension_host.dart';
import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:capyscript/modules/converter/converter_module.dart';
import 'package:capyscript/modules/date/date_module.dart';
import 'package:capyscript/modules/html/html_module.dart';
import 'package:capyscript/modules/json/json_module.dart';
import 'package:capyscript/modules/waka_models/anime/anime_models_module.dart';
import 'package:capyscript/modules/waka_models/audio/audio_models_module.dart';
import 'package:capyscript/modules/waka_models/manga/manga_models_module.dart';
import 'package:capyscript/modules/waka_models/novel/novel_models_module.dart';
import 'package:capyscript/modules/regex/regex_module.dart';
import 'package:capyscript/modules/preferences/preferences_module.dart';
import 'package:capyscript/modules/storage/storage_module.dart';
import 'package:capyscript/modules/errors/errors_module.dart';
import 'package:capyscript/modules/bytes/bytes_module.dart';
import 'package:capyscript/modules/hash/hash_module.dart';
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

typedef ModuleFactory = BaseModule Function(ExtensionHost host);

final Map<String, ModuleFactory> moduleFactories = {
  HttpModule.module_name: (ExtensionHost host) => HttpModule(host: host),
  IOModule.module_name: (_) => IOModule(),
  JsonModule.module_name: (_) => JsonModule(),
  ConverterModule.module_name: (_) => ConverterModule(),
  DateModule.module_name: (_) => DateModule(),
  HtmlModule.module_name: (_) => HtmlModule(),
  AnimeModelsModule.module_name: (_) => AnimeModelsModule(),
  MangaModelsModule.module_name: (_) => MangaModelsModule(),
  NovelModelsModule.module_name: (_) => NovelModelsModule(),
  AudioModelsModule.module_name: (_) => AudioModelsModule(),
  RegexModule.module_name: (_) => RegexModule(),
  PreferencesModule.module_name: (host) => PreferencesModule(host),
  StorageModule.module_name: (host) => StorageModule(host),
  ErrorsModule.module_name: (_) => ErrorsModule(),
  BytesModule.module_name: (_) => BytesModule(),
  HashModule.module_name: (_) => HashModule(),
};
