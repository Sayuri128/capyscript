import 'package:capyscript/AST/ast_node.dart';
import 'package:capyscript/AST/for_loop/ast_break_node.dart';
import 'package:capyscript/AST/for_loop/ast_continue_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';

class ASTForInNode extends ASTNode {
  final String variableName;
  final ASTNode iterable;
  final ASTNode body;

  const ASTForInNode({
    required this.variableName,
    required this.iterable,
    required this.body,
  });

  @override
  Future<dynamic> execute(InterpreterEnvironment environment) async {
    final source = await iterable.execute(environment);
    final List<dynamic> items;
    if (source is Map) {
      items = source.keys.toList();
    } else if (source is Iterable) {
      items = source.toList();
    } else if (source is String) {
      items = source.split('');
    } else {
      throw Exception("Cannot iterate over ${source.runtimeType} in for-in");
    }

    for (final item in items) {
      environment.budget.countLoopIteration();
      environment.setVariable(variableName, item);
      try {
        await body.execute(environment);
      } on ASTContinueNode catch (_) {
        continue;
      } on ASTBreakNode catch (_) {
        break;
      }
    }
  }
}
