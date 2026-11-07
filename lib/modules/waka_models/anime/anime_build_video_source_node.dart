import 'package:capyscript/AST/array/ast_array_node.dart';
import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/AST/map/ast_map_node.dart';
import 'package:capyscript/AST/null/ast_null_nodel.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/waka_models/anime/anime_video_source_reader.dart';
import 'package:capyscript/modules/waka_models/models/anime/anime_concrete_view/anime_video/anime_video_source.dart';

class AnimeBuildVideoSourceNode extends ModuleFunctionBody {
  static const functionName = "buildAnimeVideoSource";

  @override
  Future<dynamic> execute(InterpreterEnvironment environment) async {
    dynamic read(String name) {
      try {
        return environment.getVariable(name);
      } catch (_) {
        return null;
      }
    }

    return AnimeVideoSource(
      url: AnimeVideoSourceReader.readUrl(read("url"), functionName),
      quality: AnimeVideoSourceReader.readText(read("quality")),
      format: AnimeVideoSourceReader.readFormat(read("format")),
      headers: AnimeVideoSourceReader.readHeaders(read("headers")),
      subtitles: AnimeVideoSourceReader.readSubtitles(read("subtitles")),
    );
  }

  @override
  ASTFunctionDeclarationNode toDeclarationNode() {
    return ASTFunctionDeclarationNode(
        functionName: functionName,
        parameters: [
          ASTParameterNode("url", paramType: "any"),
          ASTParameterNode("quality",
              paramType: "any", isOptional: true, defaultValue: const ASTNullNode()),
          ASTParameterNode("format",
              paramType: "any", isOptional: true, defaultValue: const ASTNullNode()),
          ASTParameterNode("headers",
              paramType: "any",
              isOptional: true,
              defaultValue: const ASTMapNode(keys: [], values: [])),
          ASTParameterNode("subtitles",
              paramType: "any",
              isOptional: true,
              defaultValue: const ASTArrayNode(expressions: [])),
        ],
        returnType: "any",
        body: this);
  }
}
