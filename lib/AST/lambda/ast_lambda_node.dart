import 'package:capyscript/AST/lambda/ast_closure.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:json_annotation/json_annotation.dart';
import '../ast_node.dart';

part 'ast_lambda_node.g.dart';

@JsonSerializable(explicitToJson: true)
class ASTLambdaNode extends ASTNode {
  factory ASTLambdaNode.fromJson(Map<String, dynamic> json) =>
      _$ASTLambdaNodeFromJson(json);

  Map<String, dynamic> toJson() => _$ASTLambdaNodeToJson(this);

  final List<ASTParameterNode> parameters;
  final ASTNode body;
  final String? returnType;

  const ASTLambdaNode({
    required this.parameters,
    required this.body,
    this.returnType,
  });

  @override
  Future<dynamic> execute(InterpreterEnvironment environment) async {
    return ASTClosure(
      parameters: parameters,
      body: body,
      returnType: returnType,
      capturedScope: environment.currentScope,
    );
  }
}
