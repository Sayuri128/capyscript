import 'package:capyscript/AST/null/ast_null_nodel.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';

class ElementNumbering {
  final double? number;
  final int? group;

  const ElementNumbering({required this.number, required this.group});

  static List<ASTParameterNode> parameters(String groupName) => [
        ASTParameterNode("number",
            paramType: "any", isOptional: true, defaultValue: const ASTNullNode()),
        ASTParameterNode(groupName,
            paramType: "any", isOptional: true, defaultValue: const ASTNullNode()),
      ];

  factory ElementNumbering.read(
      InterpreterEnvironment environment, String groupName) {
    dynamic read(String name) {
      try {
        return environment.getVariable(name);
      } catch (_) {
        return null;
      }
    }

    return ElementNumbering(
      number: readNumber(read("number")),
      group: readGroup(read(groupName)),
    );
  }

  static num? _parse(dynamic value) {
    if (value is num) {
      return value;
    }
    if (value is String) {
      return num.tryParse(value.trim().replaceAll(',', '.'));
    }
    return null;
  }

  static double? readNumber(dynamic value) {
    final parsed = _parse(value);
    if (parsed == null || !parsed.isFinite || parsed < 0) {
      return null;
    }
    return parsed.toDouble();
  }

  static int? readGroup(dynamic value) {
    final parsed = _parse(value);
    if (parsed == null || !parsed.isFinite || parsed < 0) {
      return null;
    }
    if (parsed != parsed.truncate()) {
      return null;
    }
    return parsed.toInt();
  }
}
