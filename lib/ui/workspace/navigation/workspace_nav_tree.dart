import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/models/navigation/tree_node.dart';
import 'package:indi_tool/models/navigation/work_item.dart';
import 'package:indi_tool/providers/data/workspace_prov.dart';
import 'package:indi_tool/providers/data/workspaces_prov.dart';
import 'package:indi_tool/providers/navigation/work_item_prov.dart';
import 'package:indi_tool/schema/test_group.dart';
import 'package:indi_tool/schema/workspace.dart';

class MinimalTreeView extends ConsumerStatefulWidget {
  const MinimalTreeView({super.key});

  @override
  ConsumerState<MinimalTreeView> createState() => _MinimalTreeViewState();
}

class _MinimalTreeViewState extends ConsumerState<MinimalTreeView> {
  late final TreeController<TreeNode> treeController;
  late final TreeNode root = TreeNode(title: '/', onTap: (_) {});

  @override
  void initState() {
    super.initState();

    treeController = TreeController<TreeNode>(
      roots: root.children,
      childrenProvider: (TreeNode node) => node.children,
    );
  }

  @override
  void dispose() {
    treeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int id = ref.watch(selectedWorkspaceProvider)!;

    final Workspace workspace = ref.watch(workspacesProvider
        .select((e) => e.value?.firstWhere((e) => e.id == id)))!;

    final List<TestGroup> testGroups = workspace.testGroups;

    final List<TreeNode> groups = testGroups.map(
      (group) {
        var parent = WorkItem(
          id: group.id,
          type: WorkItemType.testGroup,
        );

        final List<TreeNode> scenarios = group.testScenarios.map(
          (scenario) {
            return TreeNode(
              title: scenario.name,
              onTap: (node) {
                ref.read(selectedWorkItemProvider.notifier).select(
                      WorkItem(
                        id: scenario.id,
                        type: WorkItemType.testScenario,
                        parent: parent,
                      ),
                    );
              },
            );
          },
        ).toList();

        return TreeNode(
          title: group.name,
          children: scenarios,
          onTap: (node) {
            ref.read(selectedWorkItemProvider.notifier).select(parent);
          },
        );
      },
    ).toList();

    treeController.roots = groups;

    return Expanded(
      child: AnimatedTreeView<TreeNode>(
        treeController: treeController,
        nodeBuilder: (BuildContext context, TreeEntry<TreeNode> entry) {
          return TreeIndentation(
            key: ValueKey(entry.node),
            entry: entry,
            child: Row(
              children: [
                if (entry.hasChildren)
                  ExpandIcon(
                    key: GlobalObjectKey(entry.node),
                    isExpanded: entry.isExpanded,
                    onPressed: (_) =>
                        treeController.toggleExpansion(entry.node),
                  )
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
