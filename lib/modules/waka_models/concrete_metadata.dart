import 'package:capyscript/AST/array/ast_array_node.dart';
import 'package:capyscript/AST/null/ast_null_nodel.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:capyscript/modules/abstract/base_module.dart';

class ConcreteMetadata {
  final List<String> authors;
  final List<String> artists;
  final int? year;
  final num? rating;
  final String? url;

  const ConcreteMetadata({
    required this.authors,
    required this.artists,
    required this.year,
    required this.rating,
    required this.url,
  });

  static List<ASTParameterNode> parameters() => [
        ASTParameterNode("authors",
            paramType: "List",
            isOptional: true,
            defaultValue: const ASTArrayNode(expressions: [])),
        ASTParameterNode("artists",
            paramType: "List",
            isOptional: true,
            defaultValue: const ASTArrayNode(expressions: [])),
        ASTParameterNode("year",
            paramType: "any", isOptional: true, defaultValue: const ASTNullNode()),
        ASTParameterNode("rating",
            paramType: "any", isOptional: true, defaultValue: const ASTNullNode()),
        ASTParameterNode("url",
            paramType: "any", isOptional: true, defaultValue: const ASTNullNode()),
      ];

  factory ConcreteMetadata.read(
      ModuleFunctionBody body, InterpreterEnvironment environment) {
    dynamic read(String name) {
      try {
        return environment.getVariable(name);
      } catch (_) {
        return null;
      }
    }

    return ConcreteMetadata(
      authors: _strings(read("authors")),
      artists: _strings(read("artists")),
      year: _year(read("year")),
      rating: _rating(read("rating")),
      url: _url(read("url")),
    );
  }

  static List<String> _strings(dynamic value) {
    if (value is! List) return const <String>[];
    final seen = <String>{};
    return [
      for (final item in value)
        if (item != null && item.toString().trim().isNotEmpty && seen.add(item.toString().trim()))
          item.toString().trim(),
    ];
  }

  static int? _year(dynamic value) {
    final int? year = value is num
        ? value.toInt()
        : value is String
            ? int.tryParse(value.trim())
            : null;
    return year != null && year > 0 ? year : null;
  }

  static num? _rating(dynamic value) {
    final num? rating = value is num
        ? value
        : value is String
            ? num.tryParse(value.trim().replaceAll(',', '.'))
            : null;
    if (rating == null || rating.isNaN) return null;
    return rating.clamp(0, 10);
  }

  static String? _url(dynamic value) {
    if (value is! String) return null;
    final trimmed = value.trim();
    return trimmed.startsWith('http://') || trimmed.startsWith('https://')
        ? trimmed
        : null;
  }
}
