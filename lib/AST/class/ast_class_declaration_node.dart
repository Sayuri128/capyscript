import 'package:capyscript/AST/ast_node.dart';
import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';

class ASTClassDeclarationNode extends ASTNode {
  final String className;
  final String? parentClass;
  final List<String> interfaces;
  final List<String> fields;
  final List<ASTFunctionDeclarationNode> methods;

  const ASTClassDeclarationNode({
    required this.className,
    this.parentClass,
    required this.interfaces,
    required this.fields,
    required this.methods,
  });

  @override
  Future<dynamic> execute(InterpreterEnvironment environment) async {
    environment.registerClass(this);
    return null;
  }
}
