class TreeNode {
  final String title;
  final List<TreeNode> children;
  final Function(TreeNode) onTap;

  TreeNode({
    required this.title,
    children,
    required this.onTap,
  }) : children = children ?? List<TreeNode>.empty(growable: true);
}
