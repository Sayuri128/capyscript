import 'token.dart';
import 'token_type.dart';

class Lexer {
  final String source;
  int _pos;

  Lexer({
    required this.source,
  }) : _pos = 0;

  Token lookupNextToken() {
    final Token nextToken = getNextToken();
    _pos--;
    return nextToken;
  }

  Token getNextToken() {
    while (_pos < source.length) {
      final currentChar = source[_pos];

      if (RegExp(r'\s').hasMatch(currentChar)) {
        _pos++; // Skip whitespace
        continue;
      }

      if (RegExp(r'\d').hasMatch(currentChar)) {
        return _parseNumber();
      }

      if (RegExp(r'[a-zA-Z_]\w*').hasMatch(currentChar)) {
        return parseIdentifier();
      }

      // Handle other token types
      _pos++;
      switch (currentChar) {
        case '+':
          return Token(TokenType.PLUS, '+');
        case '-':
          return Token(TokenType.MINUS, '-');
        case '*':
          return Token(TokenType.MULTIPLY, '*');
        case '/':
          return Token(TokenType.DIVIDE, '/');
        case '(':
          return Token(TokenType.LPAREN, '(');
        case ')':
          return Token(TokenType.RPAREN, ')');
        case ';':
          return Token(TokenType.SEMICOLON, ';');
        case ",":
          return Token(TokenType.COMMA, ",");
        case "{":
          return Token(TokenType.LBRACE, "{");
        case "}":
          return Token(TokenType.RBRACE, "}");
        case "=":
          return Token(TokenType.EQUALS, "=");
        default:
          throw Exception('Invalid token at ${--_pos}');
      }
    }

    return Token(TokenType.END, '');
  }

  Token _parseNumber() {
    var number = '';
    while (_pos < source.length && RegExp(r'^\d*\.?\d*$').hasMatch(source[_pos])) {
      number += source[_pos];
      _pos++;
    }
    return Token(TokenType.NUMBER, number);
  }

  Token parseIdentifier() {
    var identifier = '';
    while (_pos < source.length && RegExp(r'\w').hasMatch(source[_pos])) {
      identifier += source[_pos];
      _pos++;
    }
    if(identifier == "function") {
      return Token(TokenType.FUNCTION, identifier);
    }
    return Token(TokenType.IDENTIFIER, identifier);
  }
}
