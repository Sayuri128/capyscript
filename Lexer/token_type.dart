enum TokenType {
  NUMBER,
  IDENTIFIER,
  PLUS,
  MINUS,
  MULTIPLY,
  DIVIDE,
  LPAREN,
  RPAREN,
  SEMICOLON,
  END
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
