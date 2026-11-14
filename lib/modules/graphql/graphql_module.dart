import 'package:capyscript/AST/ast_tree.dart';
import 'package:capyscript/AST/map/ast_map_node.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/AST/string/ast_string_node.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/abstract/module_context.dart';
import 'package:capyscript/modules/abstract/native_function_node.dart';
import 'package:capyscript/modules/graphql/graphql_client.dart';
import 'package:capyscript/modules/http/http_module.dart';

class GraphQLModule extends BaseModule {
  static const String module_name = "graphql";

  GraphQLModule(ModuleContext context) : super(moduleName: module_name) {
    HttpModule http() => context.module(HttpModule.module_name) as HttpModule;
    body = ASTTree(functions: [
      NativeFunctionNode(
        name: "createGraphQLClient",
        parameters: [
          ASTParameterNode("url", paramType: "string"),
          ASTParameterNode("headers",
              paramType: "Map",
              isOptional: true,
              defaultValue: ASTMapNode(keys: [], values: [])),
          ASTParameterNode("method",
              paramType: "string",
              isOptional: true,
              defaultValue: ASTStringNode(value: "POST")),
        ],
        implementation: (arguments) {
          final String url = arguments["url"] as String;
          final String method = arguments["method"].toString().toUpperCase();
          if (method != "POST" && method != "GET") {
            throw Exception(
                "createGraphQLClient: method must be POST or GET, got $method");
          }
          final Uri? parsed = Uri.tryParse(url);
          if (parsed == null || !parsed.hasScheme) {
            throw Exception("createGraphQLClient: url must be absolute, got $url");
          }
          return GraphQLClient(
            url: url,
            headers: (arguments["headers"] as Map).map(
                (key, value) => MapEntry(key.toString(), value.toString())),
            useGet: method == "GET",
            http: http,
          );
        },
      ).toDeclarationNode(),
      NativeFunctionNode(
        name: "hashGraphQLQuery",
        parameters: [ASTParameterNode("query", paramType: "string")],
        returnType: "string",
        implementation: (arguments) =>
            GraphQLClient.hashQuery(arguments["query"] as String),
      ).toDeclarationNode(),
    ], modules: []);
  }
}
