import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/AST/null/ast_null_nodel.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/waka_models/models/novel/novel_chapter_content.dart';

class NovelBuildChapterNode extends ModuleFunctionBody {
  static const functionName = 'buildNovelChapter';

  @override
  Future<dynamic> execute(InterpreterEnvironment environment) async {
    final title = getVariable('title', environment);
    final html = getVariable('html', environment);
    return NovelChapterContent(
      title: title == null ? '' : title.toString(),
      html: html == null ? '' : html.toString(),
    );
  }

  @override
  ASTFunctionDeclarationNode toDeclarationNode() {
    return ASTFunctionDeclarationNode(
        functionName: functionName,
        parameters: [
          ASTParameterNode('html', paramType: 'string'),
          ASTParameterNode('title',
              paramType: 'any',
              isOptional: true,
              defaultValue: const ASTNullNode()),
        ],
        returnType: 'any',
        body: this);
  }
}
