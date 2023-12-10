import 'package:json_annotation/json_annotation.dart';
/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/ast_node.dart';

part 'ast_import_node.g.dart';

@JsonSerializable(explicitToJson: true)
class ASTImportNode extends ASTNode {

	factory ASTImportNode.fromJson(Map<String, dynamic> json) => _$ASTImportNodeFromJson(json);
	Map<String, dynamic> toJson() => _$ASTImportNodeToJson(this);

  final String moduleName;

  const ASTImportNode({
    required this.moduleName,
  });
}
