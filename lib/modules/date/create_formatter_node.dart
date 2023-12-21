/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/abstract/external_object.dart';
import 'package:intl/intl.dart';

class DateFormatter extends ExternalObject {
  final DateFormat dateFormat;

  const DateFormatter({
    required this.dateFormat,
  });

  @override
  callFunction(String name, {List? ordinalArguments}) {
    switch (name) {
      case "format":
        return dateFormat.format(ordinalArguments![0]);
    }
    throw Exception("Method $name not found");
  }

  @override
  getField(String name) {
    switch (name) {
      case "dateFormat":
        return dateFormat;
    }
    throw Exception("Field $name not found");
  }

  @override
  void setField(String name, value) {
    throw Exception("Field $name not found");
  }
}

class CreateDateFormatterNode extends ModuleFunctionBody {
  @override
  Future execute(InterpreterEnvironment environment) async {
    final value = getVariable("value", environment);
    return DateFormatter(dateFormat: DateFormat(value.toString()));
  }

  @override
  ASTFunctionDeclarationNode toDeclarationNode() {
    return ASTFunctionDeclarationNode(
        functionName: "createDateFormatter",
        parameters: [ASTParameterNode("value")],
        body: this);
  }
}
