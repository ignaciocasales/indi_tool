import 'package:indi_tool/models/navigation/tree_node.dart';
import 'package:indi_tool/providers/navigation/workspace_router_prov.dart';
import 'package:indi_tool/providers/repository/repository_prov.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'explorer_tree_prov.g.dart';

@riverpod
class ExplorerTree extends _$ExplorerTree {
  @override
  Stream<List<TreeNode>> build({required final int workspaceId}) {
    return ref
        .watch(testGroupRepositoryProvider)
        .watchTestGroupsWithScenarioList(workspaceId: workspaceId)
        .map((groups) {
      return groups.map(
        (group) {
          final List<TreeNode> scenarios = group.testScenarios.map(
            (scenario) {
              return TreeNode(
                id: scenario.id!,
                type: scenario.runtimeType,
                onTap: (node) {
                  ref
                      .read(selectedTestGroupProvider.notifier)
                      .select(group.id!);

                  ref
                      .read(selectedTestScenarioProvider.notifier)
                      .select(scenario.id!);
                },
                onDelete: (node) {
                  ref
                      .read(testScenarioRepositoryProvider)
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
              ref.read(testGroupRepositoryProvider).deleteTestGroup(group.id!);
            },
          );
        },
      ).toList();
    });
  }
}
