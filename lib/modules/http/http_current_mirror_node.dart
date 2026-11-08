import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/http/policy/http_request_policy_enforcer.dart';

class HttpCurrentMirrorNode extends ModuleFunctionBody {
  final HttpRequestPolicyEnforcer policyEnforcer;

  HttpCurrentMirrorNode({required this.policyEnforcer});

  @override
  Future<dynamic> execute(InterpreterEnvironment environment) async {
    return await policyEnforcer.currentMirror();
  }

  @override
  ASTFunctionDeclarationNode toDeclarationNode() {
    return ASTFunctionDeclarationNode(
      functionName: "currentMirror",
      parameters: [],
      returnType: "any",
      body: this,
    );
  }
}
