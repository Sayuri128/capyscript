import 'package:capyscript/AST/ast_return_value.dart';
import 'package:capyscript/AST/for_loop/ast_break_node.dart';
import 'package:capyscript/AST/for_loop/ast_continue_node.dart';
import 'package:capyscript/AST/throw/capyscript_error.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:json_annotation/json_annotation.dart';
import '../ast_node.dart';

part 'ast_try_catch_node.g.dart';

@JsonSerializable(explicitToJson: true)
class ASTTryCatchNode extends ASTNode {
  factory ASTTryCatchNode.fromJson(Map<String, dynamic> json) =>
      _$ASTTryCatchNodeFromJson(json);

  Map<String, dynamic> toJson() => _$ASTTryCatchNodeToJson(this);

  final ASTNode tryBlock;
  final String? catchVariable;
  final ASTNode? catchBlock;
  final ASTNode? finallyBlock;

  const ASTTryCatchNode({
    required this.tryBlock,
    this.catchVariable,
    this.catchBlock,
    this.finallyBlock,
  });

  @override
  Future<dynamic> execute(InterpreterEnvironment environment) async {
    try {
      await tryBlock.execute(environment);
    } on ASTReturnValue {
      rethrow;
    } on ASTBreakNode {
      rethrow;
    } on ASTContinueNode {
      rethrow;
    } catch (error) {
      if (catchBlock != null) {
        if (catchVariable != null) {
          environment.setVariable(catchVariable!, _toScriptError(error));
        }
        await catchBlock!.execute(environment);
      }
    } finally {
      if (finallyBlock != null) {
        await finallyBlock!.execute(environment);
      }
    }
    return null;
  }

  dynamic _toScriptError(Object error) {
    if (error is CapyScriptError) {
      return error.value;
    }
    var message = error.toString();
    const prefix = 'Exception: ';
    if (message.startsWith(prefix)) {
      message = message.substring(prefix.length);
    }
    return message;
  }
}
