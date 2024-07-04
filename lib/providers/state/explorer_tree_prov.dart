import 'package:indi_tool/models/navigation/tree_node.dart';
import 'package:indi_tool/providers/navigation/workspace_router_prov.dart';
import 'package:indi_tool/providers/repository/repository_prov.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'explorer_tree_prov.g.dart';

@riverpod
class ExplorerTree extends _$ExplorerTree {
  @override
  Stream<List<TreeNode>> build() {
    return ref
        .watch(testScenarioRepositoryProvider)
        .watchTestScenarioList()
        .map((scenarios) {
      return scenarios.map(
        (scenario) {
          return TreeNode(
            id: scenario.id!,
            type: scenario.runtimeType,
            onTap: (node) {
              ref
                  .read(selectedTestScenarioProvider.notifier)
                  .select(scenario.id!);
            },
            onDelete: (node) {
              final scenarioId = ref.read(selectedTestScenarioProvider);
              if (scenarioId != null && scenarioId == node.id) {
                ref.read(selectedTestScenarioProvider.notifier).clear();
              }

              ref
                  .read(testScenarioRepositoryProvider)
                  .deleteTestScenario(scenario.id!);
            },
          );
        },
      ).toList();
    });
  }
}
