import 'package:capyscript/AST/ast_reference.dart';
import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ast_node.g.dart';

@JsonSerializable()
class ASTNode {
  const ASTNode();

  factory ASTNode.fromJson(Map<String, dynamic> json) =>
      _$ASTNodeFromJson(json);

  Map<String, dynamic> toJson() => _$ASTNodeToJson(this);

  Future<dynamic> execute(InterpreterEnvironment environment) async {}

  ASTReference getReference() {
    return ASTReference.empty();
  }
}
