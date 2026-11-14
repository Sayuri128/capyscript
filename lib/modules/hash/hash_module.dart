import 'dart:convert';

import 'package:capyscript/AST/ast_tree.dart';
import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/AST/string/ast_string_node.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/abstract/native_function_node.dart';
import 'package:capyscript/modules/bytes/bytes_module.dart';
import 'package:crypto/crypto.dart';

class HashModule extends BaseModule {
  static const String module_name = "hash";

  static const Map<String, Hash> algorithms = {
    'md5': md5,
    'sha1': sha1,
    'sha256': sha256,
    'sha512': sha512,
  };

  HashModule() : super(moduleName: module_name) {
    body = ASTTree(functions: [
      for (final MapEntry<String, Hash> entry in algorithms.entries)
        _digestFunction(entry.key, entry.value),
      NativeFunctionNode(
        name: "hmac",
        parameters: [
          ASTParameterNode("algorithm", paramType: "any"),
          ASTParameterNode("key", paramType: "any"),
          ASTParameterNode("message", paramType: "any"),
          _outputParameter(),
        ],
        implementation: (arguments) {
          final Hash algorithm = _algorithm(arguments["algorithm"]);
          final Digest digest = Hmac(algorithm, input(arguments["key"], "key"))
              .convert(input(arguments["message"], "message"));
          return _format(digest, arguments["output"]);
        },
      ).toDeclarationNode(),
    ], modules: []);
  }

  static ASTFunctionDeclarationNode _digestFunction(String name, Hash hash) {
    return NativeFunctionNode(
      name: name,
      parameters: [
        ASTParameterNode("input", paramType: "any"),
        _outputParameter(),
      ],
      implementation: (arguments) => _format(
          hash.convert(input(arguments["input"], "input")), arguments["output"]),
    ).toDeclarationNode();
  }

  static ASTParameterNode _outputParameter() {
    return ASTParameterNode("output",
        paramType: "any",
        isOptional: true,
        defaultValue: ASTStringNode(value: "hex"));
  }

  static List<int> input(dynamic value, String name) {
    if (value is String) {
      return utf8.encode(value);
    }
    if (value is List) {
      return BytesModule.toBytes(value, name);
    }
    throw Exception("$name must be a string or a list of bytes, got $value");
  }

  static Hash _algorithm(dynamic name) {
    final Hash? algorithm = algorithms[name.toString().toLowerCase()];
    if (algorithm == null) {
      throw Exception(
          'unknown hash "$name", expected one of ${algorithms.keys.join(', ')}');
    }
    return algorithm;
  }

  static dynamic _format(Digest digest, dynamic output) {
    switch (output?.toString() ?? "hex") {
      case "hex":
        return digest.toString();
      case "base64":
        return base64.encode(digest.bytes);
      case "bytes":
        return digest.bytes.toList();
    }
    throw Exception('unknown output "$output", expected hex, base64 or bytes');
  }
}
