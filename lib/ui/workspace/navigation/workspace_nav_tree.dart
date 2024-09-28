import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/models/navigation/tree_node.dart';
import 'package:indi_tool/providers/state/explorer_tree_prov.dart';
import 'package:indi_tool/ui/workspace/navigation/workspace_nav_tree_entry.dart';

class WorkspaceNavTree extends ConsumerStatefulWidget {
  const WorkspaceNavTree({super.key});

  @override
  ConsumerState<WorkspaceNavTree> createState() => _MinimalTreeViewState();
}

class _MinimalTreeViewState extends ConsumerState<WorkspaceNavTree> {
  late final TreeController<TreeNode> _treeController;

  @override
  void initState() {
    super.initState();

    final roots = ref.read(explorerTreeProvider).valueOrNull;

    _treeController = TreeController<TreeNode>(
      roots: roots ?? List<TreeNode>.empty(growable: true),
      childrenProvider: (TreeNode node) {
        return node.children;
      },
    );
  }

  @override
  void dispose() {
    _treeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(explorerTreeProvider,
        (_, newValue) async {
      _treeController.roots = newValue.value ?? [];
    });

    return Expanded(
      child: AnimatedTreeView<TreeNode>(
        treeController: _treeController,
        nodeBuilder: (_, TreeEntry<TreeNode> entry) {
          return WorkspaceNavTreeEntry(
            entry: entry,
            treeController: _treeController,
          );
        },
        padding: const EdgeInsets.all(8),
        duration: const Duration(milliseconds: 300),
      ),
    );
  }
}
