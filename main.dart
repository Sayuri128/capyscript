import 'Parser/parser.dart';

void main() {

  final input = ""
      "(5 * 2) + (5 / (2 + 5))";
  final Parser parser = Parser(source: input);

  final tree = parser.parseExpression();

  print(tree.execute());

}
