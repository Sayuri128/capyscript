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

      if (source[_pos] == "\'" ||
          source[_pos] == "\"") {
        return parseString();
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
        case "\"":
          return Token(TokenType.DOUBLE_QUOTES, "\"");
        case "'":
          return Token(TokenType.SINGLE_QUOTE, "'");
        default:
          throw Exception(
              'Invalid token at ${--_pos} \n ${getRangeTokens(20)}');
      }
    }

    return Token(TokenType.END, '');
  }

  String getRangeTokens(int range) {
    final start = _pos - range / 2;
    final end = _pos + range / 2;
    return source.substring(start.clamp(0, source.length).toInt(),
        end.clamp(0, source.length).toInt());
  }

  Token _parseNumber() {
    var number = '';
    while (
        _pos < source.length && RegExp(r'^\d*\.?\d*$').hasMatch(source[_pos])) {
      number += source[_pos++];
    }
    return Token(TokenType.NUMBER, number);
  }

  Token parseString() {
    var string = '';
    _pos++;

    while (
        _pos < source.length && source[_pos] != "'" && source[_pos] != "\"") {
      string += source[_pos++];
    }

    if (_pos >= source.length ||
        (source[_pos] != "'" && source[_pos] != '\"')) {
      throw Exception('Unclosed string literal');
    }

    _pos++; // Move past the closing quote
    return Token(TokenType.STRING, string);
  }

  Token parseIdentifier() {
    var identifier = '';
    while (_pos < source.length && RegExp(r'\w').hasMatch(source[_pos])) {
      identifier += source[_pos++];
    }
    if (identifier == "function") {
      return Token(TokenType.FUNCTION, identifier);
    } else if (identifier == "import") {
      return Token(TokenType.IMPORT, identifier);
    }
    return Token(TokenType.IDENTIFIER, identifier);
  }
}
