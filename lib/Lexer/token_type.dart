enum TokenType {
  NUMBER,
  FUNCTION,
  IDENTIFIER,
  PLUS,
  MINUS,
  MULTIPLY,
  DIVIDE,
  LPAREN,
  RPAREN,
  SEMICOLON,
  END,
  COMMA,
  LBRACE,
  RBRACE,
  EQUALS
}

const Map<TokenType, String> tokenTypeRegExes = {
  TokenType.PLUS: "+",
  TokenType.MINUS: "-",
  TokenType.MULTIPLY: "*",
  TokenType.DIVIDE: "/",
  TokenType.LPAREN: "(",
  TokenType.RPAREN: ")",
  TokenType.SEMICOLON: ";",
};
