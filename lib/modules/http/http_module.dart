import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/modules/base_module.dart';
import 'package:http/http.dart' as http;

class HttpModule extends BaseModule {
  static const String moduleName = "http";

  HttpModule() {
    this.functions["get"] = ASTFunctionDeclarationNode(
        functionName: "get",
        parameters: [ASTParameterNode("url")],
        body: HttpGetNode());
  }
}

class HttpGetNode extends ModuleFunctionBody {
  @override
  Future<dynamic> execute(Map<String, Map<String, dynamic>> memory,
      Map<String, ASTFunctionDeclarationNode> functions) async {
    late final String url;
    try {
      url = memory["get"]!["url"]!;
    } catch (e) {
      throw Exception("URL not found");
    }

    final response = await http.get(Uri.parse(url));

    return response.body;
  }
}
