import 'package:capyscript/AST/ast_node.dart';
import 'package:capyscript/AST/class/ast_instance_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';

class ASTSuperNode extends ASTNode {
  final String? methodName;
  final List<ASTNode> arguments;

  const ASTSuperNode({this.methodName, required this.arguments});

  @override
  Future<dynamic> execute(InterpreterEnvironment environment) async {
    final instance = environment.getVariable('this') as ASTInstanceNode;
    final currentClass = environment.getVariable('__currentClass__') as String;
    final classDec = environment.classes[currentClass];
    if (classDec == null) {
      throw Exception("Class '$currentClass' not found");
    }
    final parentClassName = classDec.parentClass;
    if (parentClassName == null) {
      throw Exception("Class '$currentClass' has no parent class");
    }

    final resolvedArgs =
        await Future.wait(arguments.map((a) => a.execute(environment)));

    final targetMethod = methodName ?? 'constructor';
    return await instance.callMethodOnClass(
        parentClassName, targetMethod, resolvedArgs, environment);
  }
}
