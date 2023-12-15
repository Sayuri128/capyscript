/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/ast_tree.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:capyscript/modules/abstract/base_module.dart';

/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

part 'imported_module.g.dart';

@JsonSerializable(explicitToJson: true)
class ImportedModule extends BaseModule {
  factory ImportedModule.fromJson(Map<String, dynamic> json) =>
      _$ImportedModuleFromJson(json);

  Map<String, dynamic> toJson() => _$ImportedModuleToJson(this);

  ImportedModule({required ASTTree body, required super.moduleName}) {
    this.body = body;
  }
}
