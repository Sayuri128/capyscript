import 'package:capyscript/AST/ast_node.dart';
import 'package:capyscript/AST/class/ast_instance_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';

class ASTNewNode extends ASTNode {
  final String className;
  final List<ASTNode> arguments;

  const ASTNewNode({required this.className, required this.arguments});

  @override
  Future<dynamic> execute(InterpreterEnvironment environment) async {
    final classDec = environment.classes[className];
    if (classDec == null) {
      throw Exception("Class '$className' not found");
    }

    // Validate interface method requirements
    for (final ifaceName in classDec.interfaces) {
      final iface = environment.interfaces[ifaceName];
      if (iface == null) throw Exception("Interface '$ifaceName' not found");
      for (final required in iface.requiredMethods) {
        if (!_classHasMethod(className, required, environment)) {
          throw Exception(
              "Class '$className' does not implement '$required' required by interface '$ifaceName'");
        }
      }
    }

    // Collect all declared fields from the class hierarchy (null by default)
    final fields = <String, dynamic>{};
    String? current = className;
    while (current != null) {
      final c = environment.classes[current];
      if (c == null) break;
      for (final field in c.fields) {
        fields.putIfAbsent(field.name, () => null);
      }
      current = c.parentClass;
    }

    final instance = ASTInstanceNode(className: className, fields: fields);

    // Call constructor if one exists anywhere in the hierarchy
    if (_classHasMethod(className, 'constructor', environment)) {
      final resolvedArgs = await Future.wait(arguments.map((a) => a.execute(environment)));
      await instance.callMethod('constructor', resolvedArgs, environment);
    }

    return instance;
  }

  bool _classHasMethod(String startClass, String methodName, InterpreterEnvironment environment) {
    String? current = startClass;
    while (current != null) {
      final c = environment.classes[current];
      if (c == null) break;
      if (c.methods.any((m) => m.functionName == methodName)) return true;
      current = c.parentClass;
    }
    return false;
  }
}
