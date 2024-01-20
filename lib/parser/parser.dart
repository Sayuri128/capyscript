import 'package:capyscript/AST/array/ast_array_node.dart';
import 'package:capyscript/AST/ast_tree.dart';
import 'package:capyscript/AST/boolean/ast_boolean_node.dart';
import 'package:capyscript/AST/decrement/ast_decrement_node.dart';
import 'package:capyscript/AST/for_loop/ast_break_node.dart';
import 'package:capyscript/AST/for_loop/ast_continue_node.dart';
import 'package:capyscript/AST/for_loop/ast_for_loop_node.dart';
import 'package:capyscript/AST/if/ast_if_node.dart';
import 'package:capyscript/AST/import/ast_import_node.dart';
import 'package:capyscript/AST/increment/ast_increment_node.dart';
import 'package:capyscript/AST/map/ast_map_node.dart';
import 'package:capyscript/AST/method_call/method_call_node.dart';
import 'package:capyscript/AST/object/ast_object_get_node.dart';
import 'package:capyscript/AST/object/ast_object_set_node.dart';
import 'package:capyscript/AST/proprty_access/ast_property_access_node.dart';
import 'package:capyscript/AST/return/ast_return_node.dart';
import 'package:capyscript/AST/string/ast_string_node.dart';
import 'package:capyscript/AST/variable_node/ast_variable_node.dart';
import 'package:capyscript/Lexer/lexer.dart';
import 'package:capyscript/Lexer/token.dart';
import 'package:capyscript/Lexer/token_type.dart';
import 'package:capyscript/AST/assignment/ast_assignment_node.dart';
import 'package:capyscript/AST/binary_operator/ast_binary_operator_node.dart';
import 'package:capyscript/AST/block/ast_block_node.dart';
import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/AST/function_call/ast_function_call_node.dart';
import 'package:capyscript/AST/ast_node.dart';
import 'package:capyscript/AST/number/ast_number_node.dart';
import 'package:capyscript/AST/parameter/ast_parameter_node.dart';

class Parser {
  final String source;

  late final Lexer _lexer;
  ASTTree? _astTree;
  Token? _currentToken;

  Parser({required this.source}) {
    _lexer = Lexer(source: source);
    _currentToken = _lexer.getNextToken();
  }

  ASTTree parse() {
    if (_astTree != null) return _astTree!;

    final List<ASTFunctionDeclarationNode> functions = [];
    final List<ASTImportNode> imports = [];

    while (canEat([TokenType.FUNCTION, TokenType.IMPORT])) {
      if (canEat([TokenType.FUNCTION])) {
        functions.add(_parseFunctionDeclaration());
      } else if (canEat([TokenType.IMPORT])) {
        imports.add(_parseImport());
      }
    }

    _astTree = ASTTree(functions: functions, modules: imports);
    ;
    return _astTree!;
  }

  String eat(TokenType expectedToken) {
    final cur = _currentToken!;
    if (_currentToken!.type == expectedToken) {
      _currentToken = _lexer.getNextToken();
      // print("eat ${_currentToken.toString()}");
      return cur.value;
    }

    throw Exception(
        "Unexpected token - ${_currentToken!.type} - expected - ${expectedToken.toString()}");
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
      TokenType.LESS,
      TokenType.GREATER,
      TokenType.EQUAL_EQUAL,
      TokenType.NOT_EQUAL,
      TokenType.LESS_EQUAL,
      TokenType.GREATER_EQUAL
    ])) {
      final TokenType op = _currentToken!.type;
      eat(op);
      left = ASTBinaryOperatorNode(
          left: left, right: _parseFactor(functionName: functionName), op: op);
    }

    return left;
  }

  ASTNode _parsePrimary({required String functionName}) {
    if (canEat([TokenType.NUMBER])) {
      final num value = num.parse(_currentToken!.value);
      eat(TokenType.NUMBER);
      return ASTNumberNode(value: value);
    }

    if (canEat([TokenType.FALSE, TokenType.TRUE])) {
      final node = ASTBooleanNode(value: _currentToken!.type == TokenType.TRUE);
      eat(_currentToken!.type);
      return node;
    }

    if (canEat([TokenType.STRING])) {
      final string = _currentToken!.value;
      eat(TokenType.STRING);
      return ASTStringNode(value: string);
    }

    if (canEat([TokenType.PLUS])) {
      eat(TokenType.PLUS);
      return _parseFactor(functionName: functionName);
    }

    if (canEat([TokenType.MINUS])) {
      eat(TokenType.MINUS);
      return ASTBinaryOperatorNode(
          left: ASTNumberNode(value: 0),
          right: _parseFactor(functionName: functionName),
          op: TokenType.MINUS);
    }

    if (canEat([TokenType.LPAREN])) {
      eat(TokenType.LPAREN);
      final node = _parseExpression(
          functionName: functionName); // Parse expression within parentheses
      eat(TokenType.RPAREN);
      return node;
    }

    if (canEat([TokenType.NULL])) {
      eat(TokenType.NULL);
      return ASTNode();
    }

    if (canEat([TokenType.IDENTIFIER])) {
      final identifier = _currentToken!.value;
      eat(TokenType.IDENTIFIER);
      return ASTVariableNode(
          variableName: identifier, functionName: functionName);
    }

    throw Exception("Unexpected token ${_currentToken.toString()}");
  }

  ASTNode _parseFactor({required String functionName}) {
    // array
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

    // map
    if (canEat([TokenType.LBRACE])) {
      eat(TokenType.LBRACE);
      final Map<ASTNode, ASTNode> mapEntities = {};
      if (!canEat([TokenType.RBRACE])) {
        while (!canEat([TokenType.RBRACE])) {
          final keyToken = _parseExpression(functionName: functionName);
          eat(TokenType.COLON);
          final valueToken = _parseExpression(functionName: functionName);
          mapEntities[keyToken] = valueToken;

          if (canEat([TokenType.COMMA])) {
            eat(TokenType.COMMA);
          }
        }
      }
      eat(TokenType.RBRACE);
      return ASTMapNode(
          keys: mapEntities.keys.toList(), values: mapEntities.values.toList());
    }

    ASTNode factor = _parsePrimary(functionName: functionName);

    while (true) {
      if (canEat([TokenType.DOT])) {
        eat(TokenType.DOT);
        final field = eat(TokenType.IDENTIFIER);
        if (canEat([TokenType.LPAREN])) {
          factor = _parseMethodCall(functionName, factor, field);
        } else {
          factor =
              ASTPropertyAccessNode(targetExpression: factor, fieldName: field);
        }
      } else if (canEat([TokenType.LPAREN])) {
        final arguments = _parseFunctionArguments(functionName: functionName);
        factor = ASTFunctionCallNode(function: factor, arguments: arguments);
      } else if (canEat([TokenType.LSQUARE_BRACE])) {
        eat(TokenType.LSQUARE_BRACE);
        final key = _parseExpression(functionName: functionName);
        eat(TokenType.RSQUARE_BRACE);
        factor = ASTObjectGetNode(object: factor, key: key);
      } else {
        break;
      }
    }

    return factor;
  }

  ASTMethodCallNode _parseMethodCall(
      String functionName, ASTNode target, String methodName) {
    final arguments = _parseFunctionArguments(functionName: functionName);

    return ASTMethodCallNode(
        variable: target, methodName: methodName, arguments: arguments);
  }

  ASTNode _parseObjectSet(
      {required ASTNode target, required String functionName}) {
    final List<ASTNode> keyExpressions = [];
    while (canEat([TokenType.LSQUARE_BRACE])) {
      eat(TokenType.LSQUARE_BRACE);
      keyExpressions.add(_parseExpression(functionName: functionName));
      eat(TokenType.RSQUARE_BRACE);
    }

    eat(TokenType.EQUALS);

    final ASTNode value = _parseExpression(functionName: functionName);
    return ASTObjectSetNode(
        targetExpression: target,
        keyExpressions: keyExpressions,
        valueExpression: value);
  }

  ASTNode _parseIfStatement({required String functionName}) {
    eat(TokenType.IF); // Consume 'if' keyword
    final condition =
        _parseExpression(functionName: functionName); // Parse the condition
    final trueBranch = _parseBlock(
        functionName: functionName); // Parse the block for true branch

    // Check for optional 'else' branch
    ASTNode? falseBranch;
    if (_currentToken!.type == TokenType.ELSE) {
      eat(TokenType.ELSE);
      falseBranch = _currentToken!.type == TokenType.IF
          ? _parseIfStatement(functionName: functionName) // Parse if else block
          : _parseBlock(
              functionName: functionName); // Parse the block for false branch
    }

    return ASTIfNode(
        condition: condition, trueBranch: trueBranch, elseBranch: falseBranch);
  }

  List<ASTNode> _parseFunctionArguments({required String functionName}) {
    eat(TokenType.LPAREN);
    final arguments = <ASTNode>[];
    if (_currentToken!.type != TokenType.RPAREN) {
      arguments.add(_parseExpression(functionName: functionName));
      while (canEat([TokenType.COMMA])) {
        eat(TokenType.COMMA);
        arguments.add(_parseExpression(functionName: functionName));
      }
    }
    eat(TokenType.RPAREN);
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
    final parameters = _parseArguments();
    eat(TokenType.RPAREN);

    final body = _parseBlock(functionName: functionName);

    return ASTFunctionDeclarationNode(
        body: body, functionName: functionName, parameters: parameters);
  }

  List<ASTParameterNode> _parseArguments() {
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

  ASTNode _parseBlock({required String functionName}) {
    eat(TokenType.LBRACE); // Assuming TokenType.LBRACE represents '{'

    final statements = <ASTNode>[]; // Store parsed statements or expressions

    while (!canEat([TokenType.RBRACE])) {
      // Assuming TokenType.RBRACE represents '}'
      statements.add(_parseStatement(
          functionName:
              functionName)); // Parse individual statements or expressions
      if (canEat([TokenType.SEMICOLON])) {
        eat(TokenType.SEMICOLON);
      }
    }

    eat(TokenType.RBRACE); // Consume the closing curly brace

    // Return a node representing the block with all its statements
    return ASTBlockNode(statements: statements);
  }

  ASTNode _parseStatement({required String functionName}) {
    if (canEat([TokenType.IDENTIFIER])) {
      final identifier = _currentToken!.value;
      eat(TokenType.IDENTIFIER);

      if (canEat([TokenType.INCREMENT])) {
        eat(TokenType.INCREMENT);
        return ASTIncrementNode(
            variable: identifier, functionName: functionName);
      }

      if (canEat([TokenType.DECREMENT])) {
        eat(TokenType.DECREMENT);
        return ASTDecrementNode(
            variable: identifier, functionName: functionName);
      }

      ASTNode factor =
          ASTVariableNode(variableName: identifier, functionName: functionName);

      if (canEat([TokenType.LPAREN])) {
        factor = _parseFunctionCall(functionName, factor);
      }

      while (true) {
        if (canEat([TokenType.DOT])) {
          eat(TokenType.DOT);
          final field = eat(TokenType.IDENTIFIER);
          if (canEat([TokenType.LPAREN])) {
            factor = _parseMethodCall(functionName, factor, field);
          } else {
            factor = ASTPropertyAccessNode(
                targetExpression: factor, fieldName: field);
          }
        } else if (canEat([TokenType.LSQUARE_BRACE])) {
          factor = _parseObjectSet(target: factor, functionName: functionName);
        } else {
          break;
        }
      }
      if (canEat([TokenType.EQUALS])) {
        // Assuming TokenType.EQUALS represents '=' for assignment
        return _parseAssignment(functionName, factor);
      }

      return factor;
    }

    if (canEat([TokenType.IF])) {
      return _parseIfStatement(functionName: functionName);
    }

    if (canEat([TokenType.FOR])) {
      return _parseForLoopNode(functionName: functionName);
    }

    if (canEat([TokenType.BREAK])) {
      eat(TokenType.BREAK);
      return ASTBreakNode();
    }

    if (canEat([TokenType.CONTINUE])) {
      eat(TokenType.CONTINUE);
      return ASTContinueNode();
    }

    if (canEat([TokenType.RETURN])) {
      eat(TokenType.RETURN);
      return _parseReturn(functionName);
    }

    throw Exception('Invalid statement');
  }

  ASTReturnNode _parseReturn(String functionName) {
    final expression = _parseExpression(functionName: functionName);
    eat(TokenType.SEMICOLON);
    return ASTReturnNode(expression: expression);
  }

  ASTForLoopNode _parseForLoopNode({required String functionName}) {
    eat(TokenType.FOR);
    eat(TokenType.LPAREN);

    late final ASTNode initialization;
    if (!canEat([TokenType.SEMICOLON])) {
      initialization = _parseStatement(functionName: functionName);
    } else {
      initialization = ASTNode();
    }
    eat(TokenType.SEMICOLON);

    late final ASTNode condition;
    if (!canEat([TokenType.SEMICOLON])) {
      condition = _parseExpression(functionName: functionName);
    } else {
      condition = ASTNode();
    }
    eat(TokenType.SEMICOLON);

    late final ASTNode increment;
    if (!canEat([TokenType.RPAREN])) {
      increment = _parseStatement(functionName: functionName);
    } else {
      increment = ASTNode();
    }
    eat(TokenType.RPAREN);

    final body = _parseBlock(functionName: functionName);

    return ASTForLoopNode(
        initialization: initialization,
        condition: condition,
        increment: increment,
        body: body);
  }

  ASTNode _parseFunctionCall(String functionName, ASTNode target) {
    final func = ASTFunctionCallNode(
        function: target,
        arguments: _parseFunctionArguments(functionName: functionName));
    eat(TokenType.SEMICOLON);
    return func;
  }

  ASTAssignmentNode _parseAssignment(String functionName, ASTNode target) {
    eat(TokenType.EQUALS);
    final expression = _parseExpression(functionName: functionName);
    return ASTAssignmentNode(
        target: target, expression: expression, functionName: functionName);
  }
}
