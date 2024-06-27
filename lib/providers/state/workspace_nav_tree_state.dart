import 'package:indi_tool/models/navigation/tree_node.dart';
import 'package:indi_tool/models/workspace/test_group.dart';
import 'package:indi_tool/providers/navigation/workspace_router_prov.dart';
import 'package:indi_tool/providers/repository/repository_prov.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workspace_nav_tree_state.g.dart';

@riverpod
class TreeNodes extends _$TreeNodes {
  @override
  Future<List<TreeNode>> build() async {
    final List<TestGroup> groups =
        await ref.watch(testGroupsRepositoryProvider.future);

    return groups.map(
      (group) {
        final List<TreeNode> scenarios = group.testScenarios.map(
          (scenario) {
            return TreeNode(
              id: scenario.id!,
              type: scenario.runtimeType,
              onTap: (node) {
                ref.read(selectedTestGroupProvider.notifier).select(group.id!);

                ref
                    .read(selectedTestScenarioProvider.notifier)
                    .select(scenario.id!);
              },
              onDelete: (node) {
                ref
                    .read(testScenariosRepositoryProvider().notifier)
                    .deleteTestScenario(scenario.id!);
              },
            );
          },
        ).toList();

        return TreeNode(
          id: group.id!,
          type: group.runtimeType,
          children: scenarios,
          onTap: (node) {
            ref.read(selectedTestScenarioProvider.notifier).clear();
            ref.read(selectedTestGroupProvider.notifier).select(group.id!);
          },
          onDelete: (node) {
            ref
                .read(testGroupsRepositoryProvider.notifier)
                .deleteTestGroup(group.id!);
          },
        );
      },
    ).toList();
  }
}
