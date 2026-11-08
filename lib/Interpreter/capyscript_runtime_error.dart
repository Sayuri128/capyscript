import 'package:capyscript/AST/ast_return_value.dart';
import 'package:capyscript/AST/for_loop/ast_break_node.dart';
import 'package:capyscript/AST/for_loop/ast_continue_node.dart';

class CapyScriptRuntimeError implements Exception {
  final Object cause;
  final List<String> frames;

  CapyScriptRuntimeError(this.cause, this.frames);

  String get message {
    final text = cause.toString();
    const prefix = 'Exception: ';
    return text.startsWith(prefix) ? text.substring(prefix.length) : text;
  }

  static Never rethrowWithFrame(Object error, StackTrace stackTrace, String frame) {
    if (error is ASTReturnValue || error is ASTBreakNode || error is ASTContinueNode) {
      Error.throwWithStackTrace(error, stackTrace);
    }
    if (error is CapyScriptRuntimeError) {
      error.frames.add(frame);
      Error.throwWithStackTrace(error, stackTrace);
    }
    Error.throwWithStackTrace(CapyScriptRuntimeError(error, [frame]), stackTrace);
  }

  @override
  String toString() => '$message [at ${frames.join(' ← ')}]';
}
