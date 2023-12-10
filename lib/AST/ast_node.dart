import 'package:json_annotation/json_annotation.dart';
import 'ast_node_type.dart';

part 'ast_node.g.dart';


@JsonSerializable()
class ASTNode {

	const ASTNode();

	factory ASTNode.fromJson(Map<String, dynamic> json) => _$ASTNodeFromJson(json);
	Map<String, dynamic> toJson() => _$ASTNodeToJson(this);

  ASTNodeType getType() {
		return ASTNodeType.NUMBER;
	}

}
