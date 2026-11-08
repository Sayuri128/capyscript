import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/AST/map/ast_map_node.dart';
import 'package:capyscript/AST/null/ast_null_nodel.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/waka_models/anime/anime_video_source_reader.dart';
import 'package:capyscript/modules/waka_models/models/anime/anime_concrete_view/anime_video/anime_video_subtitle.dart';

class AnimeBuildVideoSubtitleNode extends ModuleFunctionBody {
  static const functionName = "buildAnimeVideoSubtitle";

  @override
  Future<dynamic> execute(InterpreterEnvironment environment) async {
    dynamic read(String name) {
      try {
        return environment.getVariable(name);
      } catch (_) {
        return null;
      }
    }

    return AnimeVideoSubtitle(
      url: AnimeVideoSourceReader.readUrl(read("url"), functionName),
      label: AnimeVideoSourceReader.readText(read("label")),
      language: AnimeVideoSourceReader.readText(read("language")),
      format: AnimeVideoSourceReader.readFormat(read("format")),
      headers: AnimeVideoSourceReader.readHeaders(read("headers")),
    );
  }

  @override
  ASTFunctionDeclarationNode toDeclarationNode() {
    return ASTFunctionDeclarationNode(
        functionName: functionName,
        parameters: [
          ASTParameterNode("url", paramType: "any"),
          ASTParameterNode("label",
              paramType: "any", isOptional: true, defaultValue: const ASTNullNode()),
          ASTParameterNode("language",
              paramType: "any", isOptional: true, defaultValue: const ASTNullNode()),
          ASTParameterNode("format",
              paramType: "any", isOptional: true, defaultValue: const ASTNullNode()),
          ASTParameterNode("headers",
              paramType: "any",
              isOptional: true,
              defaultValue: const ASTMapNode(keys: [], values: [])),
        ],
        returnType: "any",
        body: this);
  }
}
