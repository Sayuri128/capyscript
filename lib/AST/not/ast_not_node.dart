import 'package:capyscript/AST/ast_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';

class ASTNotNode extends ASTNode {
  final ASTNode expression;

  const ASTNotNode({required this.expression});

  @override
  Future<dynamic> execute(InterpreterEnvironment environment) async {
    final value = await expression.execute(environment);
    if (value is bool) {
      return !value;
    }
    return value == 0 || value == null;
  }
}
