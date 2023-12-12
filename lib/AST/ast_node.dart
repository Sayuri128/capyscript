import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ast_node.g.dart';

@JsonSerializable()
class ASTNode {
  const ASTNode();

  factory ASTNode.fromJson(Map<String, dynamic> json) =>
      _$ASTNodeFromJson(json);

  Map<String, dynamic> toJson() => _$ASTNodeToJson(this);

  Future<dynamic> execute(Map<String, Map<String, dynamic>> memory,
      Map<String, ASTFunctionDeclarationNode> functions) async {
    throw UnsupportedError("ASTNode cannot be executed");
  }
}
