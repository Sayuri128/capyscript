/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:json_annotation/json_annotation.dart';
import '../ast_node.dart';

part 'ast_parameter_node.g.dart';

@JsonSerializable(explicitToJson: true)
class ASTParameterNode extends ASTNode {
  factory ASTParameterNode.fromJson(Map<String, dynamic> json) =>
      _$ASTParameterNodeFromJson(json);

  Map<String, dynamic> toJson() => _$ASTParameterNodeToJson(this);

  final String paramName;

  ASTParameterNode(this.paramName);

}
