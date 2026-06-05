import 'package:capyscript/AST/ast_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';

class ASTInterfaceDeclarationNode extends ASTNode {
  final String interfaceName;
  final List<String> requiredMethods;

  const ASTInterfaceDeclarationNode({
    required this.interfaceName,
    required this.requiredMethods,
  });

  @override
  Future<dynamic> execute(InterpreterEnvironment environment) async {
    environment.registerInterface(this);
    return null;
  }
}
