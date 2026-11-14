import 'dart:convert';

import 'package:capyscript/AST/ast_tree.dart';
import 'package:capyscript/AST/boolean/ast_boolean_node.dart';
import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/AST/number/ast_number_node.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/AST/string/ast_string_node.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/abstract/native_function_node.dart';
import 'package:capyscript/modules/bytes/text_codecs.dart';

class BytesModule extends BaseModule {
  static const String module_name = "bytes";

  BytesModule() : super(moduleName: module_name) {
    body = ASTTree(functions: _functions(), modules: []);
  }

  static List<ASTFunctionDeclarationNode> _functions() {
    return [
      _function("base64DecodeBytes", ["text"], (arguments) {
        return base64.decode(_normalizeBase64(_text(arguments, "text"))).toList();
      }),
      _function("base64EncodeBytes", ["bytes"], (arguments) {
        return base64.encode(toBytes(arguments["bytes"], "bytes"));
      }),
      _function("hexToBytes", ["text"], (arguments) {
        final String hex = _text(arguments, "text").replaceAll(RegExp(r'\s'), '');
        if (hex.length.isOdd || !RegExp(r'^[0-9a-fA-F]*$').hasMatch(hex)) {
          throw Exception("hexToBytes: \"$hex\" is not a hex string");
        }
        return [
          for (int index = 0; index < hex.length; index += 2)
            int.parse(hex.substring(index, index + 2), radix: 16),
        ];
      }),
      _function("bytesToHex", ["bytes"], (arguments) {
        return toBytes(arguments["bytes"], "bytes")
            .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
            .join();
      }),
      NativeFunctionNode(
        name: "stringToBytes",
        parameters: [
          ASTParameterNode("text", paramType: "any"),
          _encodingParameter(),
        ],
        implementation: (arguments) => TextCodecs.encode(
            _text(arguments, "text"), _encoding(arguments)),
      ).toDeclarationNode(),
      NativeFunctionNode(
        name: "bytesToString",
        parameters: [
          ASTParameterNode("bytes", paramType: "any"),
          _encodingParameter(),
        ],
        implementation: (arguments) => TextCodecs.decode(
            toBytes(arguments["bytes"], "bytes"), _encoding(arguments)),
      ).toDeclarationNode(),
      _function("charCodes", ["text"], (arguments) {
        return _text(arguments, "text").codeUnits.toList();
      }),
      _function("fromCharCodes", ["codes"], (arguments) {
        return String.fromCharCodes(_integers(arguments["codes"], "codes"));
      }),
      NativeFunctionNode(
        name: "xorBytes",
        parameters: [
          ASTParameterNode("bytes", paramType: "any"),
          ASTParameterNode("key", paramType: "any"),
        ],
        implementation: (arguments) {
          final List<int> data = toBytes(arguments["bytes"], "bytes");
          final dynamic rawKey = arguments["key"];
          final List<int> key = rawKey is String
              ? utf8.encode(rawKey)
              : toBytes(rawKey, "key");
          if (key.isEmpty) {
            throw Exception("xorBytes: key must not be empty");
          }
          return [
            for (int index = 0; index < data.length; index++)
              data[index] ^ key[index % key.length],
          ];
        },
      ).toDeclarationNode(),
      NativeFunctionNode(
        name: "bytesToInts",
        parameters: [
          ASTParameterNode("bytes", paramType: "any"),
          ASTParameterNode("size",
              paramType: "any",
              isOptional: true,
              defaultValue: ASTNumberNode(value: 4)),
          ASTParameterNode("bigEndian",
              paramType: "bool",
              isOptional: true,
              defaultValue: ASTBooleanNode(value: true)),
          ASTParameterNode("signed",
              paramType: "bool",
              isOptional: true,
              defaultValue: ASTBooleanNode(value: false)),
        ],
        implementation: (arguments) => readIntegers(
          toBytes(arguments["bytes"], "bytes"),
          size: _integer(arguments["size"], "size"),
          bigEndian: arguments["bigEndian"] == true,
          signed: arguments["signed"] == true,
        ),
      ).toDeclarationNode(),
      _binary("bitAnd", (left, right) => left & right),
      _binary("bitOr", (left, right) => left | right),
      _binary("bitXor", (left, right) => left ^ right),
      _binary("shiftLeft", (left, right) => left << right),
      _binary("shiftRight", (left, right) => left >> right),
      _binary("shiftRightUnsigned",
          (left, right) => (left & 0xFFFFFFFF) >> (right & 31)),
      _unary("bitNot", (value) => ~value),
      _unary("toInt32", (value) => value.toSigned(32)),
      _unary("toUint32", (value) => value.toUnsigned(32)),
    ];
  }

  static List<int> readIntegers(List<int> bytes,
      {required int size, required bool bigEndian, required bool signed}) {
    if (size < 1 || size > 6) {
      throw Exception("bytesToInts: size must be between 1 and 6, got $size");
    }
    final List<int> result = [];
    for (int start = 0; start + size <= bytes.length; start += size) {
      int value = 0;
      for (int offset = 0; offset < size; offset++) {
        final int byte =
            bigEndian ? bytes[start + offset] : bytes[start + size - 1 - offset];
        value = (value << 8) | byte;
      }
      result.add(signed ? value.toSigned(size * 8) : value);
    }
    return result;
  }

  static List<int> toBytes(dynamic value, String name) {
    if (value is! List) {
      throw Exception("$name must be a list of bytes, got ${value.runtimeType}");
    }
    return [
      for (final dynamic element in value) _integer(element, name) & 0xFF,
    ];
  }

  static ASTFunctionDeclarationNode _function(String name,
      List<String> parameterNames, dynamic Function(Map<String, dynamic>) body) {
    return NativeFunctionNode(
      name: name,
      parameters: [
        for (final String parameterName in parameterNames)
          ASTParameterNode(parameterName, paramType: "any"),
      ],
      implementation: body,
    ).toDeclarationNode();
  }

  static ASTFunctionDeclarationNode _binary(
      String name, int Function(int left, int right) operation) {
    return _function(name, ["left", "right"], (arguments) {
      return operation(_integer(arguments["left"], "left"),
          _integer(arguments["right"], "right"));
    });
  }

  static ASTFunctionDeclarationNode _unary(
      String name, int Function(int value) operation) {
    return _function(
        name, ["value"], (arguments) => operation(_integer(arguments["value"], "value")));
  }

  static ASTParameterNode _encodingParameter() {
    return ASTParameterNode("encoding",
        paramType: "any",
        isOptional: true,
        defaultValue: ASTStringNode(value: "utf-8"));
  }

  static String _encoding(Map<String, dynamic> arguments) {
    final dynamic encoding = arguments["encoding"];
    if (encoding == null) {
      return "utf-8";
    }
    return encoding.toString();
  }

  static String _text(Map<String, dynamic> arguments, String name) {
    final dynamic value = arguments[name];
    if (value == null) {
      throw Exception("$name must be a string, got null");
    }
    return value.toString();
  }

  static String _normalizeBase64(String text) {
    final String compact = text.replaceAll(RegExp(r'\s'), '');
    final int remainder = compact.length % 4;
    if (remainder == 0 || compact.endsWith('=')) {
      return compact;
    }
    return compact.padRight(compact.length + 4 - remainder, '=');
  }

  static List<int> _integers(dynamic value, String name) {
    if (value is! List) {
      throw Exception("$name must be a list of numbers, got ${value.runtimeType}");
    }
    return [for (final dynamic element in value) _integer(element, name)];
  }

  static int _integer(dynamic value, String name) {
    if (value is int) {
      return value;
    }
    if (value is num && value.isFinite) {
      return value.toInt();
    }
    throw Exception("$name must be a number, got $value");
  }

}
