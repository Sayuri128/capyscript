import 'package:capyscript/AST/ast_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:capyscript/Interpreter/type_checker.dart';

class ASTVarDeclarationNode extends ASTNode {
  final String variableName;
  final String? declaredType;
  final ASTNode expression;

  const ASTVarDeclarationNode({
    required this.variableName,
    required this.expression,
    this.declaredType,
  });

  @override
  Future<dynamic> execute(InterpreterEnvironment environment) async {
    final val = await expression.execute(environment);
    if (declaredType != null) {
      TypeChecker.check(declaredType!, val, environment);
    }
    environment.setVariable(variableName, val);
    return val;
  }
}
