import 'ast_node_type.dart';

abstract class ASTNode<T> {
  const ASTNode();

  ASTNodeType getType();

  T execute();
}
