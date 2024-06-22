import 'package:uuid/uuid.dart';

class TreeNode {
  final String id;
  final String title;
  final List<TreeNode> children;
  final Function(TreeNode) onTap;
  final bool isExpanded;

  TreeNode({
    required this.title,
    id,
    children,
    onTap,
    isExpanded,
  })  : id = id ?? const Uuid().v4(),
        children = children ?? List<TreeNode>.empty(growable: true),
        onTap = onTap ?? ((_) {}),
        isExpanded = isExpanded ?? false;

  TreeNode copyWith({
    String? title,
    List<TreeNode>? children,
    Function(TreeNode)? onTap,
    bool? isExpanded,
  }) {
    return TreeNode(
      title: title ?? this.title,
      children: children ?? this.children,
      onTap: onTap ?? this.onTap,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TreeNode && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
