import 'package:capyscript/AST/ast_node.dart';
import 'package:capyscript/AST/ast_reference.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';

class ASTThisNode extends ASTNode {
  const ASTThisNode();

  @override
  Future<dynamic> execute(InterpreterEnvironment environment) async {
    return environment.getVariable('this');
  }

  @override
  ASTReference getReference() {
    return ASTReference(
      getter: (env) async => env.getVariable('this'),
      setter: (env, value) async {},
    );
  }
}
