import 'package:capyscript/AST/ast_tree.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/AST/string/ast_string_node.dart';
import 'package:capyscript/api_clients/source_error.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/abstract/native_function_node.dart';

class ErrorsModule extends BaseModule {
  static const String module_name = "errors";

  ErrorsModule() : super(moduleName: module_name) {
    body = ASTTree(
      functions: [
        NativeFunctionNode(
          name: "throwSourceError",
          parameters: [
            ASTParameterNode("kind", paramType: "any"),
            ASTParameterNode(
              "message",
              paramType: "any",
              isOptional: true,
              defaultValue: ASTStringNode(value: ""),
            ),
          ],
          returnType: "void",
          implementation: (arguments) {
            final dynamic kindName = arguments["kind"];
            final SourceErrorKind? kind = kindName is String
                ? sourceErrorKindFromName(kindName)
                : null;
            if (kind == null) {
              final String validKinds = SourceErrorKind.values
                  .map((kind) => kind.name)
                  .join(", ");
              throw Exception(
                "throwSourceError: unknown kind $kindName, expected one of $validKinds",
              );
            }
            final dynamic message = arguments["message"];
            throw SourceError(kind, message == null ? "" : message.toString());
          },
        ).toDeclarationNode(),
      ],
      modules: [],
    );
  }
}
