import 'package:flutter/material.dart';

class TreeNode {
  String title;
  List<TreeNode> children;
  bool isExpanded;

  TreeNode(
      {required this.title, this.children = const [], this.isExpanded = false});
}

class TreeNodeWidget extends StatelessWidget {
  final TreeNode node;
  final Function(TreeNode) onToggle;
  final int level;

  const TreeNodeWidget({
    super.key,
    required this.node,
    required this.onToggle,
    this.level = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: level * 16.0),
      child: Column(
        children: [
          ListTile(
            title: Text(node.title),
            trailing: node.children.isNotEmpty
                ? Icon(node.isExpanded ? Icons.expand_less : Icons.expand_more)
                : null,
            onTap: () {
              if (node.children.isNotEmpty) {
                onToggle(node);
              }
            },
          ),
          if (node.isExpanded)
            Column(
              children: node.children
                  .map((child) => TreeNodeWidget(
                        node: child,
                        onToggle: onToggle,
                        level: level + 1,
                      ))
                  .toList(),
            ),
        ],
      ),
    );
  }
}

class TreeViewExample extends StatefulWidget {
  const TreeViewExample({super.key});

  @override
  State<TreeViewExample> createState() => _TreeViewExampleState();
}

class _TreeViewExampleState extends State<TreeViewExample> {
  late List<TreeNode> treeData;

  @override
  void initState() {
    super.initState();
    treeData = _buildTreeData();
  }

  List<TreeNode> _buildTreeData() {
    return [
      TreeNode(
        title: 'Root 1',
        children: [
          TreeNode(
            title: 'Child 1.1',
            children: [
              TreeNode(title: 'Child 1.1.1'),
              TreeNode(title: 'Child 1.1.2'),
            ],
          ),
          TreeNode(title: 'Child 1.2'),
        ],
        isExpanded: true,
      ),
      TreeNode(
        title: 'Root 2',
        children: [
          TreeNode(title: 'Child 2.1'),
          TreeNode(title: 'Child 2.2'),
        ],
        isExpanded: true
      ),
    ];
  }

  void _toggleNode(TreeNode node) {
    setState(() {
      node.isExpanded = !node.isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: treeData
            .map((node) => TreeNodeWidget(
                  node: node,
                  onToggle: _toggleNode,
                ))
            .toList(),
      ),
    );
  }
}
