import 'package:capyscript/AST/ast_tree.dart';
import 'package:json_annotation/json_annotation.dart';
/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/modules/abstract/base_module.dart';

part 'interpreter_tree.g.dart';


@JsonSerializable(explicitToJson: true)
class InterpreterTree {

	factory InterpreterTree.fromJson(Map<String, dynamic> json) => _$InterpreterTreeFromJson(json);
	Map<String, dynamic> toJson( ) => _$InterpreterTreeToJson(this);


  final ASTTree astTree;
  final List<BaseModule> parsedModules;

  const InterpreterTree({
    required this.astTree,
    required this.parsedModules,
  });
}
