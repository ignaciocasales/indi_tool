import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/models/navigation/tree_node.dart';
import 'package:indi_tool/providers/state/test_groups_explorer_prov.dart';

class MinimalTreeView extends ConsumerStatefulWidget {
  const MinimalTreeView({super.key});

  @override
  ConsumerState<MinimalTreeView> createState() => _MinimalTreeViewState();
}

class _MinimalTreeViewState extends ConsumerState<MinimalTreeView> {
  late final TreeNodeController _treeController;

  @override
  void initState() {
    super.initState();

    _treeController = TreeNodeController(
      roots: List<TreeNode>.empty(growable: true),
      childrenProvider: (TreeNode node) => node.children,
    );
  }

  @override
  void dispose() {
    _treeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<TreeNode> groups = ref.watch(testGroupsExplorerProvider);

    _treeController.roots = groups;

    return Expanded(
      child: AnimatedTreeView<TreeNode>(
        treeController: _treeController,
        nodeBuilder: (BuildContext context, TreeEntry<TreeNode> entry) {
          return TreeIndentation(
            key: ValueKey(entry.node),
            entry: entry,
            child: Row(
              children: [
                if (entry.hasChildren)
                  ExpandIcon(
                      key: GlobalObjectKey(entry.node),
                      isExpanded: entry.node.isExpanded,
                      onPressed: (_) {
                        ref
                            .read(testGroupsExplorerProvider.notifier)
                            .toggleExpansion(
                              entry.node,
                            );
                      })
                else
                  const SizedBox(),
                Expanded(
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(entry.node.title),
                    ),
                    onTap: () {
                      entry.node.onTap(entry.node);
                    },
                  ),
                ),
              ],
            ),
          );
        },
        duration: const Duration(milliseconds: 100),
      ),
    );
  }
}

class TreeNodeController extends TreeController<TreeNode> {
  TreeNodeController({required super.roots, required super.childrenProvider});

  @override
  bool getExpansionState(TreeNode node) => node.isExpanded;

  // Do not call `notifyListeners` from this method as it is called many
  // times recursively in cascading operations.
  @override
  void setExpansionState(TreeNode node, bool expanded) {
    node = node.copyWith(isExpanded: expanded);
  }
}
