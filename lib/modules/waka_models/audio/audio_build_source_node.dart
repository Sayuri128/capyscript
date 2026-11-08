import 'package:capyscript/AST/array/ast_array_node.dart';
import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/AST/map/ast_map_node.dart';
import 'package:capyscript/AST/null/ast_null_nodel.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/waka_models/audio/audio_source_reader.dart';

class AudioBuildSourceNode extends ModuleFunctionBody {
  static const functionName = AudioSourceReader.builderName;

  @override
  Future<dynamic> execute(InterpreterEnvironment environment) async {
    dynamic read(String name) {
      try {
        return environment.getVariable(name);
      } catch (_) {
        return null;
      }
    }

    return AudioSourceReader.build(
      url: read('url'),
      format: read('format'),
      quality: read('quality'),
      headers: read('headers'),
      duration: read('duration'),
      markers: read('markers'),
    );
  }

  @override
  ASTFunctionDeclarationNode toDeclarationNode() {
    return ASTFunctionDeclarationNode(
        functionName: functionName,
        parameters: [
          ASTParameterNode('url', paramType: 'any'),
          ASTParameterNode('format',
              paramType: 'any',
              isOptional: true,
              defaultValue: const ASTNullNode()),
          ASTParameterNode('quality',
              paramType: 'any',
              isOptional: true,
              defaultValue: const ASTNullNode()),
          ASTParameterNode('headers',
              paramType: 'any',
              isOptional: true,
              defaultValue: const ASTMapNode(keys: [], values: [])),
          ASTParameterNode('duration',
              paramType: 'any',
              isOptional: true,
              defaultValue: const ASTNullNode()),
          ASTParameterNode('markers',
              paramType: 'any',
              isOptional: true,
              defaultValue: const ASTArrayNode(expressions: [])),
        ],
        returnType: 'any',
        body: this);
  }
}
