import 'package:capyscript/AST/throw/capyscript_error.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:json_annotation/json_annotation.dart';
import '../ast_node.dart';

part 'ast_throw_node.g.dart';

@JsonSerializable(explicitToJson: true)
class ASTThrowNode extends ASTNode {
  factory ASTThrowNode.fromJson(Map<String, dynamic> json) =>
      _$ASTThrowNodeFromJson(json);

  Map<String, dynamic> toJson() => _$ASTThrowNodeToJson(this);

  final ASTNode expression;

  const ASTThrowNode({required this.expression});

  @override
  Future<dynamic> execute(InterpreterEnvironment environment) async {
    throw CapyScriptError(await expression.execute(environment));
  }
}
