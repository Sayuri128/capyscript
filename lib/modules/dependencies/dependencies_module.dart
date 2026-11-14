import 'package:capyscript/AST/ast_tree.dart';
import 'package:capyscript/AST/lambda/ast_closure.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/abstract/environment_function_node.dart';
import 'package:capyscript/modules/abstract/native_function_node.dart';
import 'package:capyscript/modules/dependencies/dependency_registry.dart';

class DependenciesModule extends BaseModule {
  static const String module_name = "dependencies";

  DependenciesModule(DependencyRegistry registry)
      : super(moduleName: module_name) {
    body = ASTTree(functions: [
      NativeFunctionNode(
        name: "provide",
        parameters: [
          ASTParameterNode("name", paramType: "string"),
          ASTParameterNode("value", paramType: "any"),
        ],
        returnType: "void",
        implementation: (arguments) {
          registry.provide(arguments["name"] as String, arguments["value"]);
          return null;
        },
      ).toDeclarationNode(),
      NativeFunctionNode(
        name: "provideLazy",
        parameters: [
          ASTParameterNode("name", paramType: "string"),
          ASTParameterNode("factory", paramType: "any"),
        ],
        returnType: "void",
        implementation: (arguments) {
          final dynamic factory = arguments["factory"];
          if (factory is! ASTClosure) {
            throw Exception(
                'provideLazy("${arguments["name"]}"): factory must be a function, got $factory');
          }
          registry.provideLazy(arguments["name"] as String, factory);
          return null;
        },
      ).toDeclarationNode(),
      EnvironmentFunctionNode(
        name: "inject",
        parameters: [ASTParameterNode("name", paramType: "string")],
        implementation: (arguments, environment) =>
            registry.inject(arguments["name"] as String, environment),
      ).toDeclarationNode(),
      NativeFunctionNode(
        name: "isProvided",
        parameters: [ASTParameterNode("name", paramType: "string")],
        returnType: "bool",
        implementation: (arguments) =>
            registry.isProvided(arguments["name"] as String),
      ).toDeclarationNode(),
      NativeFunctionNode(
        name: "forget",
        parameters: [ASTParameterNode("name", paramType: "string")],
        returnType: "void",
        implementation: (arguments) {
          registry.forget(arguments["name"] as String);
          return null;
        },
      ).toDeclarationNode(),
    ], modules: []);
  }
}
