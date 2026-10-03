import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:capyscript/modules/abstract/base_module.dart';

class NativeFunctionNode extends ModuleFunctionBody {
  final String name;
  final List<ASTParameterNode> parameters;
  final String returnType;
  final dynamic Function(Map<String, dynamic> arguments) implementation;

  NativeFunctionNode({
    required this.name,
    required this.parameters,
    required this.implementation,
    this.returnType = "any",
  });

  @override
  Future execute(InterpreterEnvironment environment) async {
    return implementation({
      for (final parameter in parameters)
        parameter.paramName: environment.getVariable(parameter.paramName),
    });
  }

  @override
  ASTFunctionDeclarationNode toDeclarationNode() {
    return ASTFunctionDeclarationNode(
        functionName: name,
        parameters: parameters,
        returnType: returnType,
        body: this);
  }
}
