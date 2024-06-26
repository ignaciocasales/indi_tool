import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:indi_tool/models/navigation/tree_node.dart';
import 'package:indi_tool/schema/test_group.dart';
import 'package:indi_tool/schema/test_scenario.dart';
import 'package:indi_tool/ui/workspace/navigation/workspace_nav_tree_group.dart';
import 'package:indi_tool/ui/workspace/navigation/workspace_nav_tree_scenario.dart';

class WorkspaceNavTreeEntry extends StatelessWidget {
  const WorkspaceNavTreeEntry({
    super.key,
    required this.entry,
    required this.treeController,
  });

  final TreeEntry<TreeNode> entry;
  final TreeController<TreeNode> treeController;

  @override
  Widget build(BuildContext context) {
    final indentGuide = IndentGuide.scopingLines(
      color: Theme.of(context).colorScheme.primary,
    );

    return switch (entry.node.type) {
      final type when type == TestGroup => WorkspaceNavTreeGroup(
          entry: entry,
          indentGuide: indentGuide,
          treeController: treeController,
        ),
      final type when type == TestScenario => WorkspaceNavTreeScenario(
          entry: entry,
          indentGuide: indentGuide,
          treeController: treeController,
        ),
      Type() => throw UnimplementedError(),
    };
  }
}
