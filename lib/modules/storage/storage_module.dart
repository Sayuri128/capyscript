import 'dart:convert';

import 'package:capyscript/AST/ast_tree.dart';
import 'package:capyscript/AST/null/ast_null_nodel.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/api_clients/host/extension_host.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/abstract/native_function_node.dart';

class StorageModule extends BaseModule {
  static const String module_name = "storage";
  static const Duration minTtl = Duration(milliseconds: 1);
  static const Duration maxTtl = Duration(days: 3650);

  StorageModule(ExtensionHost host) : super(moduleName: module_name) {
    body = ASTTree(
      functions: [
        NativeFunctionNode(
          name: "storageGet",
          parameters: [ASTParameterNode("key", paramType: "string")],
          implementation: (arguments) async {
            final String? encoded = await host.storage.read(
              arguments["key"] as String,
            );
            return _decode(encoded);
          },
        ).toDeclarationNode(),
        NativeFunctionNode(
          name: "storageSet",
          parameters: [
            ASTParameterNode("key", paramType: "string"),
            ASTParameterNode("value", paramType: "any"),
            ASTParameterNode(
              "ttlSeconds",
              paramType: "any",
              isOptional: true,
              defaultValue: const ASTNullNode(),
            ),
          ],
          returnType: "void",
          implementation: (arguments) async {
            final String key = arguments["key"] as String;
            final dynamic value = arguments["value"];
            final String? problem = _jsonProblem(value, "value");
            if (problem != null) {
              throw Exception(
                "storageSet(\"$key\"): value is not JSON-encodable: $problem",
              );
            }
            final Duration? ttl = _ttl(key, arguments["ttlSeconds"]);
            await host.storage.write(key, jsonEncode(value), ttl: ttl);
            return null;
          },
        ).toDeclarationNode(),
        NativeFunctionNode(
          name: "storageRemove",
          parameters: [ASTParameterNode("key", paramType: "string")],
          returnType: "void",
          implementation: (arguments) async {
            await host.storage.remove(arguments["key"] as String);
            return null;
          },
        ).toDeclarationNode(),
      ],
      modules: [],
    );
  }

  static dynamic _decode(String? encoded) {
    if (encoded == null) {
      return null;
    }
    try {
      return jsonDecode(encoded);
    } on FormatException {
      return null;
    }
  }

  static Duration? _ttl(String key, dynamic ttlSeconds) {
    if (ttlSeconds == null) {
      return null;
    }
    if (ttlSeconds is! num || !ttlSeconds.isFinite || ttlSeconds <= 0) {
      throw Exception(
        "storageSet(\"$key\"): ttlSeconds must be a positive number or null, got $ttlSeconds",
      );
    }
    if (ttlSeconds >= maxTtl.inSeconds) {
      return maxTtl;
    }
    final int milliseconds = (ttlSeconds * 1000).round();
    if (milliseconds < minTtl.inMilliseconds) {
      return minTtl;
    }
    return Duration(milliseconds: milliseconds);
  }

  static String? _jsonProblem(dynamic value, String path) {
    if (value == null || value is bool || value is String) {
      return null;
    }
    if (value is num) {
      if (value.isFinite) {
        return null;
      }
      return "$path is $value";
    }
    if (value is List) {
      for (int index = 0; index < value.length; index++) {
        final String? problem = _jsonProblem(value[index], "$path[$index]");
        if (problem != null) {
          return problem;
        }
      }
      return null;
    }
    if (value is Map) {
      for (final MapEntry<dynamic, dynamic> entry in value.entries) {
        if (entry.key is! String) {
          return "$path has a non-string key ${entry.key}";
        }
        final String? problem = _jsonProblem(
          entry.value,
          "$path[\"${entry.key}\"]",
        );
        if (problem != null) {
          return problem;
        }
      }
      return null;
    }
    return "$path is a ${value.runtimeType}; only null, bool, number, string, list and map are allowed";
  }
}
