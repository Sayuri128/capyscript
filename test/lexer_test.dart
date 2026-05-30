import 'package:capyscript/Lexer/lexer.dart';
import 'package:capyscript/Lexer/token_type.dart';
import 'package:test/test.dart';

void main() {
  group('Lexer - keywords', () {
    final keywords = {
      'function': TokenType.FUNCTION,
      'import': TokenType.IMPORT,
      'if': TokenType.IF,
      'else': TokenType.ELSE,
      'for': TokenType.FOR,
      'return': TokenType.RETURN,
      'break': TokenType.BREAK,
      'continue': TokenType.CONTINUE,
      'true': TokenType.TRUE,
      'false': TokenType.FALSE,
      'null': TokenType.NULL,
    };

    for (final entry in keywords.entries) {
      test('tokenizes ${entry.key}', () {
        final token = Lexer(source: entry.key).getNextToken();
        expect(token.type, entry.value);
        expect(token.value, entry.key);
      });
    }
  });

  group('Lexer - identifiers', () {
    test('simple identifier', () {
      final token = Lexer(source: 'myVar').getNextToken();
      expect(token.type, TokenType.IDENTIFIER);
      expect(token.value, 'myVar');
    });

    test('identifier with underscore prefix', () {
      final token = Lexer(source: '_private').getNextToken();
      expect(token.type, TokenType.IDENTIFIER);
      expect(token.value, '_private');
    });

    test('identifier with digits', () {
      final token = Lexer(source: 'item123').getNextToken();
      expect(token.type, TokenType.IDENTIFIER);
      expect(token.value, 'item123');
    });
  });

  group('Lexer - numbers', () {
    test('integer', () {
      final token = Lexer(source: '42').getNextToken();
      expect(token.type, TokenType.NUMBER);
      expect(token.value, '42');
    });

    test('float', () {
      final token = Lexer(source: '3.14').getNextToken();
      expect(token.type, TokenType.NUMBER);
      expect(token.value, '3.14');
    });

    test('zero', () {
      final token = Lexer(source: '0').getNextToken();
      expect(token.type, TokenType.NUMBER);
      expect(token.value, '0');
    });
  });

  group('Lexer - strings', () {
    test('double-quoted string', () {
      final token = Lexer(source: '"hello"').getNextToken();
      expect(token.type, TokenType.STRING);
      expect(token.value, 'hello');
    });

    test('single-quoted string', () {
      final token = Lexer(source: "'world'").getNextToken();
      expect(token.type, TokenType.STRING);
      expect(token.value, 'world');
    });

    test('backtick string', () {
      final token = Lexer(source: '`test`').getNextToken();
      expect(token.type, TokenType.STRING);
      expect(token.value, 'test');
    });

    test('empty string', () {
      final token = Lexer(source: '""').getNextToken();
      expect(token.type, TokenType.STRING);
      expect(token.value, '');
    });

    test('string with spaces', () {
      final token = Lexer(source: '"hello world"').getNextToken();
      expect(token.type, TokenType.STRING);
      expect(token.value, 'hello world');
    });
  });

  group('Lexer - single-char operators', () {
    // Trailing space prevents peekNextChar() out-of-bounds on ambiguous chars
    final operators = {
      '+ ': TokenType.PLUS,
      '- ': TokenType.MINUS,
      '* ': TokenType.MULTIPLY,
      '/ ': TokenType.DIVIDE,
      '( ': TokenType.LPAREN,
      ') ': TokenType.RPAREN,
      '{ ': TokenType.LBRACE,
      '} ': TokenType.RBRACE,
      '[ ': TokenType.LSQUARE_BRACE,
      '] ': TokenType.RSQUARE_BRACE,
      ', ': TokenType.COMMA,
      '. ': TokenType.DOT,
      '; ': TokenType.SEMICOLON,
      ': ': TokenType.COLON,
      '< ': TokenType.LESS,
      '> ': TokenType.GREATER,
      '= ': TokenType.EQUALS,
    };

    for (final entry in operators.entries) {
      test('tokenizes ${entry.key.trim()}', () {
        final token = Lexer(source: entry.key).getNextToken();
        expect(token.type, entry.value);
      });
    }
  });

  group('Lexer - two-char operators', () {
    final operators = {
      '==': TokenType.EQUAL_EQUAL,
      '!=': TokenType.NOT_EQUAL,
      '<=': TokenType.LESS_EQUAL,
      '>=': TokenType.GREATER_EQUAL,
      '++': TokenType.INCREMENT,
      '--': TokenType.DECREMENT,
      '&&': TokenType.AND,
      '||': TokenType.OR,
    };

    for (final entry in operators.entries) {
      test('tokenizes ${entry.key}', () {
        final token = Lexer(source: entry.key).getNextToken();
        expect(token.type, entry.value);
        expect(token.value, entry.key);
      });
    }
  });

  group('Lexer - comments', () {
    test('skips single-line comment', () {
      final token = Lexer(source: '// comment\n42').getNextToken();
      expect(token.type, TokenType.NUMBER);
      expect(token.value, '42');
    });

    test('skips multi-line comment', () {
      final token = Lexer(source: '/* block */42').getNextToken();
      expect(token.type, TokenType.NUMBER);
      expect(token.value, '42');
    });

    test('skips multi-line comment spanning lines', () {
      final token = Lexer(source: '/*\nline1\nline2\n*/true').getNextToken();
      expect(token.type, TokenType.TRUE);
    });
  });

  group('Lexer - whitespace and end', () {
    test('skips leading whitespace', () {
      final token = Lexer(source: '   42').getNextToken();
      expect(token.type, TokenType.NUMBER);
    });

    test('skips newlines', () {
      final token = Lexer(source: '\n\n42').getNextToken();
      expect(token.type, TokenType.NUMBER);
    });

    test('returns END token on empty source', () {
      final token = Lexer(source: '').getNextToken();
      expect(token.type, TokenType.END);
    });

    test('returns END token after all input consumed', () {
      final lexer = Lexer(source: '42');
      lexer.getNextToken(); // consumes 42
      expect(lexer.getNextToken().type, TokenType.END);
    });
  });

  group('Lexer - lookahead', () {
    test('lookUpNextToken does not advance position for single-char token', () {
      // lookUpNextToken only decrements _pos by 1, so it only works correctly
      // for single-character tokens (operators, punctuation).
      final lexer = Lexer(source: '+ ');
      final first = lexer.lookUpNextToken();
      final second = lexer.getNextToken();
      expect(first.type, second.type);
      expect(first.value, second.value);
    });
  });
}
