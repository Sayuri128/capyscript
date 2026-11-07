import 'package:capyscript/AST/array/ast_array_node.dart';
import 'package:capyscript/AST/null/ast_null_nodel.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:capyscript/modules/waka_models/concrete_metadata.dart';

class GalleryMetadata {
  final String? subtitle;
  final List<String> tags;
  final int? year;
  final num? rating;
  final String? latestChapter;

  const GalleryMetadata({
    required this.subtitle,
    required this.tags,
    required this.year,
    required this.rating,
    required this.latestChapter,
  });

  static List<ASTParameterNode> parameters() => [
        ASTParameterNode("subtitle",
            paramType: "any", isOptional: true, defaultValue: const ASTNullNode()),
        ASTParameterNode("tags",
            paramType: "List",
            isOptional: true,
            defaultValue: const ASTArrayNode(expressions: [])),
        ASTParameterNode("year",
            paramType: "any", isOptional: true, defaultValue: const ASTNullNode()),
        ASTParameterNode("rating",
            paramType: "any", isOptional: true, defaultValue: const ASTNullNode()),
        ASTParameterNode("latestChapter",
            paramType: "any", isOptional: true, defaultValue: const ASTNullNode()),
      ];

  factory GalleryMetadata.read(InterpreterEnvironment environment) {
    dynamic read(String name) {
      try {
        return environment.getVariable(name);
      } catch (_) {
        return null;
      }
    }

    return GalleryMetadata(
      subtitle: readText(read("subtitle")),
      tags: ConcreteMetadata.readStrings(read("tags")),
      year: ConcreteMetadata.readYear(read("year")),
      rating: ConcreteMetadata.readRating(read("rating")),
      latestChapter: readText(read("latestChapter")),
    );
  }

  static String? readText(dynamic value) {
    if (value is! String && value is! num) return null;
    final trimmed = value.toString().trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}
