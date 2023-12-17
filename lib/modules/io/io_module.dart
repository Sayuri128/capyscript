import 'package:capyscript/AST/ast_tree.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:json_annotation/json_annotation.dart';
/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/modules/abstract/base_module.dart';

part 'io_module.g.dart';

@JsonSerializable(explicitToJson: true)
class IOModule extends BaseModule {
  factory IOModule.fromJson(Map<String, dynamic> json) =>
      _$IOModuleFromJson(json);

  Map<String, dynamic> toJson() => _$IOModuleToJson(this);

  static const String module_name = "io";

  IOModule() : super(moduleName: module_name) {
    final List<ASTFunctionDeclarationNode> functions = [];
    functions.add(ASTFunctionDeclarationNode(
        functionName: "print",
        parameters: [ASTParameterNode("data")],
        body: IOPrintNode()));

    body = ASTTree(functions: functions, modules: [], classes: []);
  }
}

class IOPrintNode extends ModuleFunctionBody {
  @override
  Future execute(InterpreterEnvironment environment) async {
    late final dynamic data;
    try {
      data = environment.getVariable("data");
    } catch (e) {
      throw Exception("data not found");
    }

    print(data);

    return null;
  }
}
