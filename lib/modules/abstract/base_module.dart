/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/ast_tree.dart';
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

class ModuleFunctionBody extends ASTNode {}

final Map<String, BaseModule> modules = {
  HttpModule.module_name: HttpModule(),
  IOModule.module_name: IOModule()
};
