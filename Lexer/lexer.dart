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

      // Handle other token types
      switch (currentChar) {
        case '+':
          _pos++;
          return Token(TokenType.PLUS, '+');
        case '-':
          _pos++;
          return Token(TokenType.MINUS, '-');
        case '*':
          _pos++;
          return Token(TokenType.MULTIPLY, '*');
        case '/':
          _pos++;
          return Token(TokenType.DIVIDE, '/');
        case '(':
          _pos++;
          return Token(TokenType.LPAREN, '(');
        case ')':
          _pos++;
          return Token(TokenType.RPAREN, ')');
        case ';':
          _pos++;
          return Token(TokenType.SEMICOLON, ';');
        default:
          throw Exception('Invalid token');
      }
    }

    return Token(TokenType.END, '');
  }

  Token _parseNumber() {
    var number = '';
    while (_pos < source.length && RegExp(r'\d').hasMatch(source[_pos])) {
      number += source[_pos];
      _pos++;
    }
    return Token(TokenType.NUMBER, number);
  }
}
