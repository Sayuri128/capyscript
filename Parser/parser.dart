import '../AST/ast_binary_operator_node.dart';
import '../AST/ast_node.dart';
import '../AST/ast_number_node.dart';
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

  ASTNode<dynamic> parseExpression() {
    return parseTerm();
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

  ASTNode<dynamic> parseTerm() {
    ASTNode<dynamic> left = parseFactor();

    while (canEat([
      TokenType.PLUS,
      TokenType.MINUS,
      TokenType.MULTIPLY,
      TokenType.DIVIDE,
    ])) {
      final Token token = _currentToken!;
      final TokenType op = token.type;

      eat(op);
      left = ASTBinaryOperatorNode(left: left, right: parseFactor(), op: op);
    }

    return left;
  }

  ASTNode<dynamic> parseFactor() {
    final Token token = _currentToken!;

    if (token.type == TokenType.NUMBER) {
      double value = double.parse(token.value);
      eat(TokenType.NUMBER);
      return ASTNumberNode(value: value);
    }

    if (token.type == TokenType.PLUS) {
      eat(TokenType.PLUS);
      return parseFactor();
    }

    if (token.type == TokenType.MINUS) {
      eat(TokenType.MINUS);
      return ASTBinaryOperatorNode(
          left: ASTNumberNode(value: 0),
          right: parseFactor(),
          op: TokenType.MINUS);
    }

    if (token.type == TokenType.LPAREN) {
      eat(TokenType.LPAREN);
      final node = parseTerm(); // Parse expression within parentheses
      eat(TokenType.RPAREN);
      return node;
    }


    throw Exception("Unexpected token");
  }
}
