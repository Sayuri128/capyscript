import '../Lexer/token_type.dart';
import 'ast_node.dart';
import 'ast_node_type.dart';

class ASTBinaryOperatorNode extends ASTNode<dynamic> {
  final ASTNode<dynamic> left;
  final ASTNode<dynamic> right;
  final TokenType op;

  @override
  dynamic execute() {
    final leftRes = left.execute();
    final rightRes = right.execute();
    print(leftRes.toString() + " ${op} " + rightRes.toString());

    switch (op) {
      case TokenType.PLUS:
        return leftRes + rightRes;
      case TokenType.MINUS:
        return leftRes - rightRes;
      case TokenType.MULTIPLY:
        return leftRes * rightRes;
      case TokenType.DIVIDE:
        return leftRes / rightRes;
      default:
        return leftRes + rightRes;
    }
  }

  @override
  ASTNodeType getType() {
    return ASTNodeType.BINARY_OPERATION;
  }

  const ASTBinaryOperatorNode({
    required this.left,
    required this.right,
    required this.op,
  });
}
