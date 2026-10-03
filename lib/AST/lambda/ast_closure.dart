import 'package:capyscript/AST/ast_node.dart';
import 'package:capyscript/AST/ast_return_value.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/Interpreter/capyscript_runtime_error.dart';
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
    final callEnvironment = environment.closureEnvironment(capturedScope);
    try {
      for (int i = 0; i < parameters.length; i++) {
        final param = parameters[i];
        if (i < arguments.length) {
          callEnvironment.defineVariable(param.paramName, arguments[i]);
        } else if (param.isOptional && param.defaultValue != null) {
          callEnvironment.defineVariable(param.paramName,
              await param.defaultValue!.execute(callEnvironment));
        }
        if (param.paramType != null) {
          TypeChecker.check(param.paramType!,
              callEnvironment.getVariable(param.paramName), callEnvironment);
        }
      }

      dynamic res;
      try {
        res = await body.execute(callEnvironment);
      } on ASTReturnValue catch (r) {
        res = await r.execute(callEnvironment);
      }

      if (returnType != null && returnType != 'void') {
        TypeChecker.check(returnType!, res, callEnvironment);
      }

      return res;
    } catch (e, st) {
      CapyScriptRuntimeError.rethrowWithFrame(e, st, '<lambda>');
    }
  }

  @override
  String toString() => '<lambda>';
}
