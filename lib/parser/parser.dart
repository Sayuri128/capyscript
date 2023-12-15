import 'package:capyscript/AST/array/ast_array_node.dart';
import 'package:capyscript/AST/ast_result.dart';
import 'package:capyscript/AST/import/ast_import_node.dart';
import 'package:capyscript/AST/method_call/method_call_node.dart';
import 'package:capyscript/AST/return/ast_return_node.dart';
import 'package:capyscript/AST/string/ast_string_node.dart';
import 'package:capyscript/AST/variable_node/ast_variable_node.dart';
import 'package:capyscript/Lexer/lexer.dart';
import 'package:capyscript/Lexer/token.dart';
import 'package:capyscript/Lexer/token_type.dart';
import 'package:capyscript/modules/base_module.dart';

import '../AST/assignment/ast_assignment_node.dart';
import '../AST/binary_operator/ast_binary_operator_node.dart';
import '../AST/block/ast_block_node.dart';
import '../AST/function_declaration/ast_funcation_declaration_node.dart';
import '../AST/function_call/ast_function_call_node.dart';
import '../AST/ast_node.dart';
import '../AST/number/ast_number_node.dart';
import '../AST/parameter/ast_parameter_node.dart';

class Parser {
  final String source;

  late final Lexer _lexer;
  Token? _currentToken;

  Parser({
    required this.source,
  }) {
    _lexer = Lexer(source: source);
    _currentToken = _lexer.getNextToken();
  }

  ASTResult parse() {
    final List<ASTFunctionDeclarationNode> functions = [];
    final List<ASTImportNode> imports = [];

    while (_currentToken?.type == TokenType.FUNCTION ||
        _currentToken?.type == TokenType.IMPORT) {
      if (_currentToken?.type == TokenType.FUNCTION) {
        functions.add(_parseFunctionDeclaration());
      } else if (_currentToken?.type == TokenType.IMPORT) {
        imports.add(_parseImport());
      }
    }
    try {
      functions.firstWhere((element) => element.functionName == "main");
    } catch (e) {
      throw Exception("main function not found");
    }

    for (final import in imports) {
      final module = modules[import.moduleName];
      if (module == null) {
        throw Exception("Module ${import.moduleName} not found");
      }
      module.functions.forEach((key, value) {
        if (functions.any((element) => element.functionName == key)) {
          throw Exception("Found Function duplicates - ${key}");
        }
        functions.add(value);
      });
    }

    return ASTResult(functions: functions, modules: imports);
  }

  void eat(TokenType expectedToken) {
    if (_currentToken!.type == expectedToken) {
      _currentToken = _lexer.getNextToken();
      // print("eat ${_currentToken.toString()}");
      return;
    }

    throw Exception("Unexpected token! ${_currentToken!.type}");
  }

  void eatOr(List<TokenType> expectedTokens) {
    if (expectedTokens.any((element) => element == _currentToken!.type)) {
      _currentToken = _lexer.getNextToken();
      return;
    }
    throw Exception("Unexpected Token! ${_currentToken!.type}");
  }

  bool canEat(List<TokenType> tokens) {
    return tokens.any((element) => element == _currentToken!.type);
  }

  ASTNode _parseExpression({required String functionName}) {
    return _parseTerm(functionName: functionName);
  }

  ASTNode _parseTerm({required String functionName}) {
    ASTNode left = _parseFactor(functionName: functionName);

    while (canEat([
      TokenType.PLUS,
      TokenType.MINUS,
      TokenType.MULTIPLY,
      TokenType.DIVIDE,
    ])) {
      final TokenType op = _currentToken!.type;

      eat(op);
      left = ASTBinaryOperatorNode(
          left: left, right: _parseFactor(functionName: functionName), op: op);
    }

    return left;
  }

  ASTNode _parseFactor({required String functionName}) {
    if (_currentToken!.type == TokenType.NUMBER) {
      double value = double.parse(_currentToken!.value);
      eat(TokenType.NUMBER);
      return ASTNumberNode(value: value);
    }

    if (canEat([TokenType.LSQUARE_BRACE])) {
      eat(TokenType.LSQUARE_BRACE);
      final List<ASTNode> values = [];
      while (!canEat([TokenType.RSQUARE_BRACE])) {
        values.add(_parseExpression(functionName: functionName));
        if (canEat([TokenType.COMMA])) {
          eat(TokenType.COMMA);
        }
      }
      eat(TokenType.RSQUARE_BRACE);
      return ASTArrayNode(expressions: values);
    }

    if (canEat([TokenType.STRING])) {
      final string = _currentToken!.value;
      eat(TokenType.STRING);
      return ASTStringNode(value: string);
    }

    if (_currentToken!.type == TokenType.PLUS) {
      eat(TokenType.PLUS);
      return _parseFactor(functionName: functionName);
    }

    if (_currentToken!.type == TokenType.MINUS) {
      eat(TokenType.MINUS);
      return ASTBinaryOperatorNode(
          left: ASTNumberNode(value: 0),
          right: _parseFactor(functionName: functionName),
          op: TokenType.MINUS);
    }

    if (_currentToken!.type == TokenType.LPAREN) {
      eat(TokenType.LPAREN);
      final node = _parseTerm(
          functionName: functionName); // Parse expression within parentheses
      eat(TokenType.RPAREN);
      return node;
    }

    if (_currentToken!.type == TokenType.IDENTIFIER) {
      String identifier = _currentToken!.value;
      eat(TokenType.IDENTIFIER);
      if (_currentToken!.type == TokenType.LPAREN) {
        eat(TokenType.LPAREN);
        final arguments = _parseFunctionArguments(functionName: functionName);
        eat(TokenType.RPAREN);
        return ASTFunctionCallNode(
            functionName: identifier, arguments: arguments);
      }

      if (canEat([TokenType.DOT])) {
        eat(TokenType.DOT);
        final methodName = _currentToken!.value;
        eat(TokenType.IDENTIFIER);
        eat(TokenType.LPAREN);
        final arguments = _parseFunctionArguments(functionName: methodName);
        eat(TokenType.RPAREN);
        return ASTMethodCallNode(
            variable: ASTVariableNode(
                functionName: functionName, variableName: identifier),
            methodName: methodName,
            arguments: arguments);
      }

      return ASTVariableNode(
          variableName: identifier, functionName: functionName);
    }

    throw Exception("Unexpected token ${_currentToken.toString()}");
  }

  List<ASTNode> _parseFunctionArguments({required String functionName}) {
    final arguments = <ASTNode>[];
    if (_currentToken!.type != TokenType.RPAREN) {
      arguments.add(_parseExpression(functionName: functionName));
      while (canEat([TokenType.COMMA])) {
        eat(TokenType.COMMA);
        arguments.add(_parseExpression(functionName: functionName));
      }
    }
    return arguments;
  }

  ASTImportNode _parseImport() {
    if (_currentToken!.type == TokenType.IMPORT) {
      eat(TokenType.IMPORT);
      final moduleName = _currentToken!.value;
      eat(TokenType.STRING);
      eat(TokenType.SEMICOLON);
      return ASTImportNode(moduleName: moduleName);
    }
    throw Exception("Cannot parse import module");
  }

  ASTFunctionDeclarationNode _parseFunctionDeclaration() {
    eat(TokenType.FUNCTION);

    final functionName = _currentToken!.value;
    eat(TokenType.IDENTIFIER);

    eat(TokenType.LPAREN);
    final parameters = _parseParameters();
    eat(TokenType.RPAREN);

    final body = _parseBlock(functionName);

    return ASTFunctionDeclarationNode(
        body: body, functionName: functionName, parameters: parameters);
  }

  List<ASTParameterNode> _parseParameters() {
    final parameters = <ASTParameterNode>[];
    if (_currentToken!.type != TokenType.RPAREN) {
      parameters.add(ASTParameterNode(_currentToken!.value));
      eat(TokenType.IDENTIFIER);
      while (canEat([TokenType.COMMA])) {
        eat(TokenType.COMMA);
        parameters.add(ASTParameterNode(_currentToken!.value));
        eat(TokenType.IDENTIFIER);
      }
    }
    return parameters;
  }

  ASTNode _parseBlock(String functionName) {
    eat(TokenType.LBRACE); // Assuming TokenType.LBRACE represents '{'

    final statements = <ASTNode>[]; // Store parsed statements or expressions

    while (!canEat([TokenType.RBRACE])) {
      // Assuming TokenType.RBRACE represents '}'
      statements.add(_parseStatement(
          functionName:
              functionName)); // Parse individual statements or expressions
    }

    eat(TokenType.RBRACE); // Consume the closing curly brace

    // Return a node representing the block with all its statements
    return ASTBlockNode(statements: statements);
  }

  ASTNode _parseStatement({required String functionName}) {
    if (_currentToken!.type == TokenType.IDENTIFIER) {
      final identifier = _currentToken!.value;
      eat(TokenType.IDENTIFIER);

      if (_currentToken!.type == TokenType.EQUALS) {
        // Assuming TokenType.EQUALS represents '=' for assignment
        eat(TokenType.EQUALS);
        final expression = _parseExpression(functionName: functionName);
        eat(TokenType.SEMICOLON); // Assuming TokenType.SEMICOLON represents ';'
        return ASTAssignmentNode(
            variableName: identifier,
            expression: expression,
            functionName: functionName);
      }
      if (_currentToken!.type == TokenType.LPAREN) {
        eat(TokenType.LPAREN);
        final arguments = _parseFunctionArguments(functionName: functionName);
        eat(TokenType.RPAREN);
        eat(TokenType.SEMICOLON);
        return ASTFunctionCallNode(
            functionName: identifier, arguments: arguments);
      }

      if (canEat([TokenType.DOT])) {
        eat(TokenType.DOT);
        final methodName = _currentToken!.value;
        eat(TokenType.IDENTIFIER);
        eat(TokenType.LPAREN);
        final arguments = _parseFunctionArguments(functionName: functionName);
        eat(TokenType.RPAREN);
        eat(TokenType.SEMICOLON);

        return ASTMethodCallNode(
            variable: ASTVariableNode(
                variableName: identifier, functionName: functionName),
            methodName: methodName,
            arguments: arguments);
      }

      if (identifier == "return") {
        final expression = _parseExpression(functionName: functionName);
        eat(TokenType.SEMICOLON);
        return ASTReturnNode(expression: expression);
      }
    }

    throw Exception('Invalid statement');
  }
}
