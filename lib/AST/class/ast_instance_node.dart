import 'package:capyscript/AST/ast_return_value.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';

class ASTInstanceNode {
  final String className;
  final Map<String, dynamic> fields;

  ASTInstanceNode({required this.className, required this.fields});

  dynamic getField(String name) => fields[name];

  void setField(String name, dynamic value) => fields[name] = value;

  Future<dynamic> callMethod(
    String methodName,
    List<dynamic> resolvedArgs,
    InterpreterEnvironment environment,
  ) async {
    return callMethodOnClass(className, methodName, resolvedArgs, environment);
  }

  Future<dynamic> callMethodOnClass(
    String startClass,
    String methodName,
    List<dynamic> resolvedArgs,
    InterpreterEnvironment environment,
  ) async {
    final method = _findMethod(startClass, methodName, environment);
    if (method == null) {
      throw Exception("Method '$methodName' not found on class '$className'");
    }

    final owningClass = _findOwningClass(startClass, methodName, environment)!;

    environment.enterScope();
    environment.setVariable('this', this);
    environment.setVariable('__currentClass__', owningClass);

    for (int i = 0; i < method.parameters.length; i++) {
      if (i < resolvedArgs.length) {
        environment.setVariable(method.parameters[i].paramName, resolvedArgs[i]);
      } else if (method.parameters[i].isOptional && method.parameters[i].defaultValue != null) {
        environment.setVariable(
          method.parameters[i].paramName,
          await method.parameters[i].defaultValue!.execute(environment),
        );
      }
    }

    dynamic res;
    try {
      res = await method.execute(environment);
    } on ASTReturnValue catch (r) {
      res = await r.execute(environment);
    }

    environment.exitScope();
    return res;
  }

  dynamic _findMethod(
    String startClass,
    String methodName,
    InterpreterEnvironment environment,
  ) {
    String? current = startClass;
    while (current != null) {
      final classDec = environment.classes[current];
      if (classDec == null) break;
      final method = classDec.methods.where((m) => m.functionName == methodName).firstOrNull;
      if (method != null) return method;
      current = classDec.parentClass;
    }
    return null;
  }

  String? _findOwningClass(
    String startClass,
    String methodName,
    InterpreterEnvironment environment,
  ) {
    String? current = startClass;
    while (current != null) {
      final classDec = environment.classes[current];
      if (classDec == null) break;
      if (classDec.methods.any((m) => m.functionName == methodName)) return current;
      current = classDec.parentClass;
    }
    return null;
  }
}
