import '../AST/assignment/ast_assignment_node.dart';
import '../AST/binary_operator/ast_binary_operator_node.dart';
import '../AST/block/ast_block_node.dart';
import '../AST/function_declaration/ast_funcation_declaration_node.dart';
import '../AST/function_call/ast_function_call_node.dart';
import '../AST/ast_node.dart';
import '../AST/number/ast_number_node.dart';
import '../AST/parameter/ast_parameter_node.dart';
import '../Lexer/lexer.dart';
import '../Lexer/token.dart';
import '../Lexer/token_type.dart';

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

  List<ASTNode> parse() {
    final List<ASTNode> functions = [];
    while (_currentToken?.type == TokenType.FUNCTION) {
      functions.add(_parseFunctionDeclaration());
    }
    return functions;
  }

  ASTNode _parseExpression() {
    return _parseTerm();
  }

  void eat(TokenType expectedToken) {
    if (_currentToken!.type == expectedToken) {
      _currentToken = _lexer.getNextToken();
      return;
    }

    throw Exception("Unexpected token! ${_currentToken!.type}");
  }

  bool canEat(List<TokenType> tokens) {
    return tokens.any((element) => element == _currentToken!.type);
  }

  ASTNode _parseTerm() {
    ASTNode left = _parseFactor();

    while (canEat([
      TokenType.PLUS,
      TokenType.MINUS,
      TokenType.MULTIPLY,
      TokenType.DIVIDE,
    ])) {
      final TokenType op = _currentToken!.type;

      eat(op);
      left = ASTBinaryOperatorNode(left: left, right: _parseFactor(), op: op);
    }

    return left;
  }

  ASTNode _parseFactor() {

    if (_currentToken!.type == TokenType.NUMBER) {
      double value = double.parse(_currentToken!.value);
      eat(TokenType.NUMBER);
      return ASTNumberNode(value: value);
    }

    if (_currentToken!.type == TokenType.PLUS) {
      eat(TokenType.PLUS);
      return _parseFactor();
    }

    if (_currentToken!.type == TokenType.MINUS) {
      eat(TokenType.MINUS);
      return ASTBinaryOperatorNode(
          left: ASTNumberNode(value: 0),
          right: _parseFactor(),
          op: TokenType.MINUS);
    }

    if (_currentToken!.type == TokenType.LPAREN) {
      eat(TokenType.LPAREN);
      final node = _parseTerm(); // Parse expression within parentheses
      eat(TokenType.RPAREN);
      return node;
    }

    if (_currentToken!.type == TokenType.IDENTIFIER) {
      String functionName = _currentToken!.value;
      eat(TokenType.IDENTIFIER);
      if (_currentToken!.type == TokenType.LPAREN) {
        eat(TokenType.RPAREN);
        final arguments = _parseFunctionArguments();
        eat(TokenType.RPAREN);
        return ASTFunctionCallNode(
            functionName: functionName, arguments: arguments);
      }
    }

    throw Exception("Unexpected token");
  }

  List<ASTNode> _parseFunctionArguments() {

    final arguments = <ASTNode>[];
    if (_currentToken!.type != TokenType.RPAREN) {
      arguments.add(_parseExpression());
      while (canEat([TokenType.COMMA])) {
        eat(TokenType.COMMA);
        arguments.add(_parseExpression());
      }
    }
    return arguments;
  }

  ASTNode _parseFunctionDeclaration() {
    eat(TokenType.FUNCTION);

    final functionName = _currentToken!.value;
    eat(TokenType.IDENTIFIER);

    eat(TokenType.LPAREN);
    final parameters = _parseParameters();
    eat(TokenType.RPAREN);

    final body = _parseBlock();

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

  ASTNode _parseBlock() {
    eat(TokenType.LBRACE); // Assuming TokenType.LBRACE represents '{'

    final statements = <ASTNode>[]; // Store parsed statements or expressions

    while (!canEat([TokenType.RBRACE])) {
      // Assuming TokenType.RBRACE represents '}'
      statements.add(
          _parseStatement()); // Parse individual statements or expressions
    }

    eat(TokenType.RBRACE); // Consume the closing curly brace

    // Return a node representing the block with all its statements
    return ASTBlockNode(statements: statements);
  }

  ASTNode _parseStatement() {

    if (_currentToken!.type == TokenType.IDENTIFIER) {
      final variableName = _currentToken!.value;
      eat(TokenType.IDENTIFIER);

      if (_currentToken!.type == TokenType.EQUALS) {
        // Assuming TokenType.EQUALS represents '=' for assignment
        eat(TokenType.EQUALS);
        final expression = _parseExpression();
        eat(TokenType.SEMICOLON); // Assuming TokenType.SEMICOLON represents ';'
        return ASTAssignmentNode(
            variableName: variableName, expression: expression);
      }
    }

    throw Exception('Invalid statement');
  }
}
