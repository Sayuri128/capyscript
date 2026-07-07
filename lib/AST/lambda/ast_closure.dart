import 'package:capyscript/AST/ast_node.dart';
import 'package:capyscript/AST/ast_return_value.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:capyscript/Interpreter/interpreter_scoped_environment.dart';
import 'package:capyscript/Interpreter/type_checker.dart';

class ASTClosure {
  final List<ASTParameterNode> parameters;
  final ASTNode body;
  final String? returnType;
  final InterpreterScopedEnvironment capturedScope;

  ASTClosure({
    required this.parameters,
    required this.body,
    required this.capturedScope,
    this.returnType,
  });

  Future<dynamic> call(
      InterpreterEnvironment environment, List<dynamic> arguments) async {
    final saved = environment.currentScope;
    environment.enterScopeWith(capturedScope);
    try {
      for (int i = 0; i < parameters.length; i++) {
        final param = parameters[i];
        if (i < arguments.length) {
          environment.setVariable(param.paramName, arguments[i]);
        } else if (param.isOptional && param.defaultValue != null) {
          environment.setVariable(
              param.paramName, await param.defaultValue!.execute(environment));
        }
        if (param.paramType != null) {
          TypeChecker.check(param.paramType!,
              environment.getVariable(param.paramName), environment);
        }
      }

      dynamic res;
      try {
        res = await body.execute(environment);
      } on ASTReturnValue catch (r) {
        res = await r.execute(environment);
      }

      if (returnType != null && returnType != 'void') {
        TypeChecker.check(returnType!, res, environment);
      }

      return res;
    } finally {
      environment.restoreScope(saved);
    }
  }

  @override
  String toString() => '<lambda>';
}
