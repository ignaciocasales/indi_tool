import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/providers/providers.dart';
import 'package:indi_tool/services/http/http_request.dart';

class TreeNode {
  String title;
  List<TreeNode> children;
  bool isExpanded;

  TreeNode(
      {required this.title, this.children = const [], this.isExpanded = false});
}

class TreeNodeWidget extends StatelessWidget {
  final TreeNode node;
  final Function(TreeNode) onTap;
  final int level;

  const TreeNodeWidget({
    super.key,
    required this.node,
    required this.onTap,
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
              onTap(node);
            },
          ),
          if (node.isExpanded)
            Column(
              children: node.children
                  .map((child) => TreeNodeWidget(
                        node: child,
                        onTap: onTap,
                        level: level + 1,
                      ))
                  .toList(),
            ),
        ],
      ),
    );
  }
}

class TreeViewExample extends ConsumerWidget {
  const TreeViewExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<IndiHttpRequest> requestList = ref.watch(requestListProvider);

    return Expanded(
      child: ListView(
        children: requestList
            .map(
              (request) => TreeNodeWidget(
                node: TreeNode(title: request.name),
                onTap: (node) {
                  ref.read(selectedRequestProvider.notifier).select(request);
                },
              ),
            )
            .toList(),
      ),
    );
  }
}

