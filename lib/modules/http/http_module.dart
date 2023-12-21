import 'package:capyscript/AST/ast_tree.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:http/http.dart' as http;

part 'http_module.g.dart';

@JsonSerializable(explicitToJson: true)
class HttpModule extends BaseModule {
  static const String module_name = "http";

  factory HttpModule.fromJson(Map<String, dynamic> json) =>
      _$HttpModuleFromJson(json);

  Map<String, dynamic> toJson() => _$HttpModuleToJson(this);

  HttpModule() : super(moduleName: module_name) {
    final List<ASTFunctionDeclarationNode> functions = [];
    functions.add(ASTFunctionDeclarationNode(
        functionName: "get",
        parameters: [ASTParameterNode("url")],
        body: HttpGetNode()));
    body = ASTTree(functions: functions, modules: []);
  }
}

class HttpGetNode extends ModuleFunctionBody {
  @override
  Future<dynamic> execute(InterpreterEnvironment environment) async {
    late final String url;
    try {
      url = environment.getVariable("url");
    } catch (e) {
      throw Exception("URL not found");
    }

    final response = await http.get(Uri.parse(url));

    return response.body;
  }
}
