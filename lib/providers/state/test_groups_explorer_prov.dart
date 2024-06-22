import 'package:indi_tool/models/navigation/tree_node.dart';
import 'package:indi_tool/models/navigation/work_item.dart';
import 'package:indi_tool/providers/data/workspace_prov.dart';
import 'package:indi_tool/providers/data/workspaces_prov.dart';
import 'package:indi_tool/providers/navigation/work_item_prov.dart';
import 'package:indi_tool/schema/test_group.dart';
import 'package:indi_tool/schema/workspace.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'test_groups_explorer_prov.g.dart';

@riverpod
class TestGroupsExplorer extends _$TestGroupsExplorer {
  final List<bool> _expansionState = List<bool>.empty(growable: true);

  @override
  List<TreeNode> build() {
    return _build();
  }

  void toggleExpansion(TreeNode node) {
    final int index = state.indexOf(node);
    _expansionState[index] = !_expansionState[index];
    state = _build();
  }

  List<TreeNode> _build() {
    final int id = ref.watch(selectedWorkspaceProvider)!;

    final Workspace workspace = ref.watch(workspacesProvider
        .select((e) => e.value?.firstWhere((e) => e.id == id)))!;

    final List<TestGroup> testGroups = workspace.testGroups;

    final List<TreeNode> groups = testGroups
        .asMap()
        .map(
          (index, group) {
            final WorkItem parent = WorkItem(
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

            final bool expansionState =
                _expansionState.elementAtOrNull(index) ?? false;
            // Update the expansion state list
            if (_expansionState.length <= index) {
              _expansionState.add(expansionState);
            } else {
              _expansionState[index] = expansionState;
            }

            return MapEntry(
              index,
              TreeNode(
                title: group.name,
                children: scenarios,
                onTap: (node) {
                  ref.read(selectedWorkItemProvider.notifier).select(parent);
                },
                isExpanded: expansionState,
              ),
            );
          },
        )
        .values
        .toList();

    if (groups.length < _expansionState.length) {
      _expansionState.removeRange(groups.length, _expansionState.length);
    }

    return groups;
  }
}
