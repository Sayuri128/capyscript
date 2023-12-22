import 'package:capyscript/AST/array/ast_array_node.dart';
import 'package:capyscript/AST/ast_reference.dart';
import 'package:capyscript/AST/external_value/ast_external_value_node.dart';
import 'package:capyscript/AST/map/ast_map_node.dart';
import 'package:capyscript/AST/number/ast_number_node.dart';
import 'package:capyscript/AST/string/ast_string_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ast_node.g.dart';

@JsonSerializable()
class ASTNode {
  const ASTNode();

  factory ASTNode.fromJson(Map<String, dynamic> json) =>
      _$ASTNodeFromJson(json);

  Map<String, dynamic> toJson() => _$ASTNodeToJson(this);

  Future<dynamic> execute(InterpreterEnvironment environment) async {
    return null;
  }

  factory ASTNode.fromValue(dynamic value) {
    if (value is Map) {
      return ASTMapNode.fromMap(value);
    }
    if (value is num) {
      return ASTNumberNode(value: value);
    }
    if (value is String) {
      return ASTStringNode(value: value);
    }
    if (value is List) {
      return ASTArrayNode.fromList(value);
    }
    return ASTExternalValueNode(value: value);
  }

  ASTReference getReference() {
    return ASTReference.empty();
  }
}
