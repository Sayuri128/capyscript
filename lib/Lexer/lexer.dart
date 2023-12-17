import 'token.dart';
import 'token_type.dart';

class Lexer {
  final String source;
  int _pos;

  Lexer({
    required this.source,
  }) : _pos = 0;

  Token lookUpNextToken() {
    final Token nextToken = getNextToken();
    _pos--;
    return nextToken;
  }

  String peekNextChar() {
    return source[_pos + 1];
  }

  void _advance() {
    _pos++; // Move to the next character
  }

  Token getNextToken() {
    while (_pos < source.length) {
      final currentChar = source[_pos];

      if (RegExp(r'\s').hasMatch(currentChar)) {
        _advance(); // Skip whitespace
        continue;
      }

      if (RegExp(r'\d').hasMatch(currentChar)) {
        return _parseNumber();
      }

      if (source[_pos] == "\'" || source[_pos] == "\"") {
        return parseString();
      }

      if (RegExp(r'[a-zA-Z_]\w*').hasMatch(currentChar)) {
        return parseIdentifier();
      }

      if (currentChar == '=' && peekNextChar() == '=') {
        _advance();
        _advance();
        return Token(TokenType.EQUAL_EQUAL, '==');
      } else if (currentChar == '<' && peekNextChar() == "=") {
        _advance();
        _advance();
        return Token(TokenType.LESS_EQUAL, '<=');
      } else if (currentChar == '>' && peekNextChar() == '=') {
        _advance();
        _advance();
        return Token(TokenType.GREATER_EQUAL, '>=');
      } else if (currentChar == "+" && peekNextChar() == "+") {
        _advance();
        _advance();
        return Token(TokenType.INCREMENT, "++");
      } else if (currentChar == "-" && peekNextChar() == "-") {
        _advance();
        _advance();
        return Token(TokenType.DECREMENT, "--");
      }

      _advance();
      switch (currentChar) {
        case '+':
          return Token(TokenType.PLUS, currentChar);
        case '-':
          return Token(TokenType.MINUS, currentChar);
        case '*':
          return Token(TokenType.MULTIPLY, currentChar);
        case '/':
          return Token(TokenType.DIVIDE, currentChar);
        case '(':
          return Token(TokenType.LPAREN, currentChar);
        case ')':
          return Token(TokenType.RPAREN, currentChar);
        case ';':
          return Token(TokenType.SEMICOLON, currentChar);
        case ",":
          return Token(TokenType.COMMA, currentChar);
        case "{":
          return Token(TokenType.LBRACE, currentChar);
        case "}":
          return Token(TokenType.RBRACE, currentChar);
        case "=":
          return Token(TokenType.EQUALS, currentChar);
        case "\"":
          return Token(TokenType.DOUBLE_QUOTES, currentChar);
        case "'":
          return Token(TokenType.SINGLE_QUOTE, currentChar);
        case "[":
          return Token(TokenType.LSQUARE_BRACE, currentChar);
        case "]":
          return Token(TokenType.RSQUARE_BRACE, currentChar);
        case ":":
          return Token(TokenType.COLON, currentChar);
        case ".":
          return Token(TokenType.DOT, currentChar);
        case "<":
          return Token(TokenType.LESS, currentChar);
        case ">":
          return Token(TokenType.GREATER, currentChar);
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
    _advance();

    while (
        _pos < source.length && source[_pos] != "'" && source[_pos] != "\"") {
      string += source[_pos++];
    }

    if (_pos >= source.length ||
        (source[_pos] != "'" && source[_pos] != '\"')) {
      throw Exception('Unclosed string literal');
    }

    _advance();
    return Token(TokenType.STRING, string);
  }

  Token parseIdentifier() {
    var identifier = '';
    while (_pos < source.length && RegExp(r'\w').hasMatch(source[_pos])) {
      identifier += source[_pos];
      _advance();
    }
    if (identifier == "function") {
      return Token(TokenType.FUNCTION, identifier);
    } else if (identifier == "import") {
      return Token(TokenType.IMPORT, identifier);
    } else if (identifier == "if") {
      return Token(TokenType.IF, identifier);
    } else if (identifier == 'else') {
      return Token(TokenType.ELSE, identifier);
    } else if (identifier == "true") {
      return Token(TokenType.TRUE, identifier);
    } else if (identifier == "false") {
      return Token(TokenType.FALSE, identifier);
    } else if (identifier == "for") {
      return Token(TokenType.FOR, identifier);
    } else if (identifier == "break") {
      return Token(TokenType.BREAK, identifier);
    } else if (identifier == "continue") {
      return Token(TokenType.CONTINUE, identifier);
    } else if (identifier == "class") {
      return Token(TokenType.CLASS, identifier);
    } else if (identifier == "new") {
      return Token(TokenType.NEW, identifier);
    }
    // else if (identifier == "this") {
    //   return Token(TokenType.THIS, identifier);
    // }
    else if(identifier == "return") {
      return Token(TokenType.RETURN, identifier);
    }
    return Token(TokenType.IDENTIFIER, identifier);
  }
}
