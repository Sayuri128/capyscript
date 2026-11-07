import 'package:capyscript/AST/ast_tree.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/api_clients/host/extension_host.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/abstract/native_function_node.dart';

class PreferencesModule extends BaseModule {
  static const String module_name = "preferences";

  PreferencesModule(ExtensionHost host) : super(moduleName: module_name) {
    body = ASTTree(
      functions: [
        NativeFunctionNode(
          name: "getPreference",
          parameters: [ASTParameterNode("key", paramType: "string")],
          implementation: (arguments) async {
            final Object? value = await host.resolvePreference(
              arguments["key"] as String,
            );
            return toScriptValue(value);
          },
        ).toDeclarationNode(),
      ],
      modules: [],
    );
  }

  static dynamic toScriptValue(Object? value) {
    if (value is List) {
      return value.map(toScriptValue).toList();
    }
    if (value is Map) {
      return <String, dynamic>{
        for (final MapEntry<dynamic, dynamic> entry in value.entries)
          entry.key.toString(): toScriptValue(entry.value),
      };
    }
    return value;
  }
}
