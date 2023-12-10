import 'ast_node.dart';
import 'ast_node_type.dart';

class ASTNumberNode extends ASTNode<double> {
  final double value;

  @override
  double execute() {
    return value;
  }

  @override
  ASTNodeType getType() {
    return ASTNodeType.NUMBER;
  }

  const ASTNumberNode({
    required this.value,
  });
}
