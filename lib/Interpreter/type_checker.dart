import 'package:capyscript/AST/class/ast_instance_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';

class TypeChecker {
  static void check(
    String typeName,
    dynamic value,
    InterpreterEnvironment env,
  ) {
    final trimmed = typeName.trim();
    final base = trimmed.contains('<')
        ? trimmed.substring(0, trimmed.indexOf('<')).trim()
        : trimmed;

    switch (base) {
      case 'any':
      case 'dynamic':
      case 'void':
        return;
      case 'int':
        if (value is num && value == value.truncate()) return;
        throw Exception('TypeError: expected int, got ${_describe(value)}');
      case 'float':
      case 'double':
        if (value is num) return;
        throw Exception('TypeError: expected float, got ${_describe(value)}');
      case 'string':
        if (value is String) return;
        throw Exception('TypeError: expected string, got ${_describe(value)}');
      case 'bool':
        if (value is bool) return;
        throw Exception('TypeError: expected bool, got ${_describe(value)}');
      case 'List':
        if (value is List) return;
        throw Exception('TypeError: expected List, got ${_describe(value)}');
      case 'Map':
        if (value is Map) return;
        throw Exception('TypeError: expected Map, got ${_describe(value)}');
      default:
        if (value is ASTInstanceNode && _isSubtype(value.className, base, env)) {
          return;
        }
        throw Exception(
            'TypeError: expected $typeName, got ${_describe(value)}');
    }
  }

  static bool _isSubtype(
    String className,
    String target,
    InterpreterEnvironment env,
  ) {
    String? current = className;
    while (current != null) {
      if (current == target) return true;
      current = env.classes[current]?.parentClass;
    }
    return false;
  }

  static String _describe(dynamic v) {
    if (v == null) return 'null';
    if (v is bool) return 'bool';
    if (v is int) return 'int';
    if (v is double) return v == v.truncateToDouble() ? 'int' : 'float';
    if (v is num) return 'float';
    if (v is String) return 'string';
    if (v is List) return 'List';
    if (v is Map) return 'Map';
    if (v is ASTInstanceNode) return v.className;
    return v.runtimeType.toString();
  }
}
