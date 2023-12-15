/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/modules/base_module.dart';

class IOModule extends BaseModule {
  static const String moduleName = "io";

  IOModule() {
    this.functions["print"] = ASTFunctionDeclarationNode(
        functionName: "print",
        parameters: [ASTParameterNode("data")],
        body: IOPrintNode());
  }
}

class IOPrintNode extends ModuleFunctionBody {
  @override
  Future execute(Map<String, Map<String, dynamic>> memory,
      Map<String, ASTFunctionDeclarationNode> functions) async {
    late final dynamic data;
    try {
      data = memory["print"]!["data"];
    } catch (e) {
      throw Exception("data not found");
    }

    print(data);

    return null;
  }
}
