import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/models/navigation/tree_node.dart';
import 'package:indi_tool/models/workspace/test_scenario.dart';
import 'package:indi_tool/providers/repository/repository_prov.dart';

class WorkspaceNavTreeScenario extends ConsumerWidget {
  const WorkspaceNavTreeScenario({
    super.key,
    required this.entry,
    required this.indentGuide,
    required this.treeController,
  });

  final TreeEntry<TreeNode> entry;
  final IndentGuide indentGuide;
  final TreeController<TreeNode> treeController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TestScenario? testScenario =
        ref.watch(testScenarioProvider(scenarioId: entry.node.id)).valueOrNull;

    if (testScenario == null) {
      return const Text('Scenario not found');
    }

    return TreeIndentation(
      key: ValueKey(entry.node),
      entry: entry,
      guide: indentGuide,
      child: Row(
        children: [
          _getLeadingFor(entry),
          _getTrailingFor(entry, testScenario),
        ],
      ),
    );
  }

  Widget _getLeadingFor(final TreeEntry<TreeNode> entry) {
    return const SizedBox();
  }

  Widget _getTrailingFor(
    final TreeEntry<TreeNode> entry,
    final TestScenario testScenario,
  ) {
    return Expanded(
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  testScenario.name,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _getMenuAnchorFor(entry),
            ],
          ),
        ),
        onTap: () {
          entry.node.onTap(entry.node);
        },
      ),
    );
  }

  Widget _getMenuAnchorFor(final TreeEntry<TreeNode> entry) {
    return MenuAnchor(
      builder: (BuildContext ctx, MenuController controller, Widget? child) {
        return IconButton(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: const Icon(Icons.more_horiz_outlined),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        );
      },
      menuChildren: [
        MenuItemButton(
          child: const Row(
            children: [
              Icon(
                Icons.delete_rounded,
                size: 16,
              ),
              SizedBox(width: 8),
              Text('Delete'),
            ],
          ),
          onPressed: () {
            // TODO: show dialog.
            entry.node.onDelete(entry.node);
          },
        ),
      ],
    );
  }
}
