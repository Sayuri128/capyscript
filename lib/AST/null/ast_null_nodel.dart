import 'package:json_annotation/json_annotation.dart';
/*
 * Copyright (c) 2024 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/ast_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';

part 'ast_null_nodel.g.dart';

@JsonSerializable(explicitToJson: true)
class ASTNullNode extends ASTNode {

	factory ASTNullNode.fromJson(Map<String, dynamic> json) => _$ASTNullNodeFromJson(json);
	Map<String, dynamic> toJson( ) => _$ASTNullNodeToJson(this);

  const ASTNullNode();

  @override
  Future execute(InterpreterEnvironment environment) async {
    return null;
  }
}
