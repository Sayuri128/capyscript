import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/AST/null/ast_null_nodel.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/waka_models/models/audio/audio_marker.dart';

class AudioBuildMarkerNode extends ModuleFunctionBody {
  static const functionName = 'buildAudioMarker';

  @override
  Future<dynamic> execute(InterpreterEnvironment environment) async {
    final title = getVariable('title', environment);
    final start = AudioMarker.readSeconds(getVariable('start', environment));
    if (start == null) {
      throw Exception('$functionName: start must be a non-negative number of seconds');
    }
    return AudioMarker(
      title: title == null ? '' : title.toString().trim(),
      start: start,
    );
  }

  @override
  ASTFunctionDeclarationNode toDeclarationNode() {
    return ASTFunctionDeclarationNode(
        functionName: functionName,
        parameters: [
          ASTParameterNode('start', paramType: 'any'),
          ASTParameterNode('title',
              paramType: 'any',
              isOptional: true,
              defaultValue: const ASTNullNode()),
        ],
        returnType: 'any',
        body: this);
  }
}
