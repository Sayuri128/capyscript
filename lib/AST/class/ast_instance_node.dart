import 'package:capyscript/AST/ast_return_value.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:capyscript/Interpreter/type_checker.dart';

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
    try {
      environment.setVariable('this', this);
      environment.setVariable('__currentClass__', owningClass);

      for (int i = 0; i < method.parameters.length; i++) {
        final param = method.parameters[i];
        if (i < resolvedArgs.length) {
          environment.setVariable(param.paramName, resolvedArgs[i]);
        } else if (param.isOptional && param.defaultValue != null) {
          environment.setVariable(
            param.paramName,
            await param.defaultValue!.execute(environment),
          );
        }
        if (param.paramType != null) {
          TypeChecker.check(
              param.paramType!, environment.getVariable(param.paramName), environment);
        }
      }

      dynamic res;
      try {
        res = await method.execute(environment);
      } on ASTReturnValue catch (r) {
        res = await r.execute(environment);
      }

      if (method.returnType != null && method.returnType != 'void') {
        TypeChecker.check(method.returnType!, res, environment);
      }

      return res;
    } finally {
      environment.exitScope();
    }
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
