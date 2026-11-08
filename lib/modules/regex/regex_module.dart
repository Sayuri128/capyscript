import 'package:capyscript/AST/ast_tree.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/AST/string/ast_string_node.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/abstract/native_function_node.dart';

class RegexModule extends BaseModule {
  static const String module_name = "regex";

  RegexModule() : super(moduleName: module_name) {
    body = ASTTree(functions: [
      _function("regexTest", (pattern, input, _) => pattern.hasMatch(input),
          returnType: "bool"),
      _function("regexMatch", (pattern, input, _) {
        final match = pattern.firstMatch(input);
        return match == null ? null : _groups(match);
      }),
      _function("regexMatchAll",
          (pattern, input, _) => pattern.allMatches(input).map(_groups).toList(),
          returnType: "List"),
      _function("regexSplit", (pattern, input, _) => input.split(pattern),
          returnType: "List"),
      _function(
          "regexReplace",
          (pattern, input, replacement) => input.replaceAllMapped(
              pattern, (match) => _expand(replacement!, match)),
          withReplacement: true,
          returnType: "string"),
    ].map((e) => e.toDeclarationNode()).toList(), modules: []);
  }

  static NativeFunctionNode _function(
    String name,
    dynamic Function(RegExp pattern, String input, String? replacement) body, {
    bool withReplacement = false,
    String returnType = "any",
  }) {
    return NativeFunctionNode(
      name: name,
      returnType: returnType,
      parameters: [
        ASTParameterNode("pattern", paramType: "string"),
        ASTParameterNode("input", paramType: "string"),
        if (withReplacement) ASTParameterNode("replacement", paramType: "string"),
        ASTParameterNode("flags",
            paramType: "string",
            isOptional: true,
            defaultValue: ASTStringNode(value: "")),
      ],
      implementation: (arguments) {
        final flags = arguments["flags"] as String;
        final pattern = RegExp(
          arguments["pattern"] as String,
          caseSensitive: !flags.contains("i"),
          multiLine: flags.contains("m"),
          dotAll: flags.contains("s"),
        );
        return body(pattern, arguments["input"] as String,
            arguments["replacement"] as String?);
      },
    );
  }

  static List<String?> _groups(RegExpMatch match) =>
      [for (var i = 0; i <= match.groupCount; i++) match.group(i)];

  static String _expand(String replacement, Match match) {
    return replacement.replaceAllMapped(RegExp(r'\$(\$|\d+)'), (m) {
      final token = m.group(1)!;
      if (token == r'$') {
        return r'$';
      }
      final index = int.parse(token);
      return index <= match.groupCount ? (match.group(index) ?? '') : m.group(0)!;
    });
  }
}
