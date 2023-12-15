import 'token_type.dart';

class Token {
  final TokenType type;
  final String value;

  Token(this.type, this.value);

  @override
  String toString() {
    return 'Token{type: $type, value: $value}';
  }
}
