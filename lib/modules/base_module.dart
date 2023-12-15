/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/ast_node.dart';
import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/modules/http/http_module.dart';
import 'package:capyscript/modules/io/io_module.dart';

abstract class BaseModule {
  final Map<String, ASTFunctionDeclarationNode> functions = {};

  BaseModule();
}

class ModuleFunctionBody extends ASTNode {}

final Map<String, BaseModule> modules = {
  HttpModule.moduleName: HttpModule(),
  IOModule.moduleName: IOModule()
};
