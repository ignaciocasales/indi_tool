class TreeNode {
  TreeNode({
    required this.id,
    Type? type,
    List<TreeNode>? children,
    Function(TreeNode)? onTap,
    Function(TreeNode)? onDelete,
  })  : type = type ?? dynamic,
        children = children ?? List<TreeNode>.empty(growable: true),
        onTap = onTap ?? ((_) {}),
        onDelete = onDelete ?? ((_) {});

  final int id;
  final Type type;
  final List<TreeNode> children;
  final Function(TreeNode) onTap;
  final Function(TreeNode) onDelete;

  TreeNode copyWith({
    List<TreeNode>? children,
    Function(TreeNode)? onTap,
    Function(TreeNode)? onDelete,
  }) {
    return TreeNode(
      id: id,
      children: children ?? this.children,
      onTap: onTap ?? this.onTap,
      onDelete: onDelete ?? this.onDelete,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TreeNode && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
