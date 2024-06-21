import 'package:indi_tool/core/exceptions/invalid_work_item_type.dart';
import 'package:indi_tool/models/navigation/work_item.dart';
import 'package:indi_tool/providers/data/test_groups_prov.dart';
import 'package:indi_tool/providers/injection/dependency_prov.dart';
import 'package:indi_tool/providers/navigation/work_item_prov.dart';
import 'package:indi_tool/schema/test_group.dart';
import 'package:indi_tool/schema/test_scenario.dart';
import 'package:indi_tool/schema/workspace.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'test_scenarios_prov.g.dart';

@riverpod
class TestScenarios extends _$TestScenarios {
  @override
  Future<List<TestScenario>> build() async {
    final Isar isar = await ref.read(isarProvider.future);

    final WorkItem workItem = ref.read(selectedWorkItemProvider)!;

    if (workItem.type != WorkItemType.testScenario) {
      throw InvalidWorkItemType(workItem.type);
    }

    final List<Workspace> workspaces = isar.workspaces.where().findAll();

    final TestGroup testGroup = workspaces
        .map((e) => e.testGroups)
        .expand((e) => e)
        .firstWhere((e) => e.testScenarios.indexWhere((e) => e.id == workItem.id) != -1);


    return testGroup.testScenarios;
  }

  Future<TestScenario> getTestScenario(final String id) async {
    final Isar isar = await ref.read(isarProvider.future);

    throw UnimplementedError();
  }

  Future<TestScenario> addTestScenario(final TestGroup testGroup) async {
    final Isar isar = await ref.read(isarProvider.future);

    final List<Workspace> workspaces = isar.workspaces.where().findAll();
    final Workspace workspace = workspaces
        .where(
            (q) => q.testGroups.indexWhere((e) => e.id == testGroup.id) != -1)
        .first;

    final newTestScenario = TestScenario.newWith(
      name: 'New Test Scenario',
    );

    final TestGroup updated =
        workspace.testGroups.where((e) => e.id == testGroup.id).first;
    updated.testScenarios.add(newTestScenario);

    await ref.read(testGroupsProvider.notifier).updateTestGroup(updated);

    state = AsyncValue.data(updated.testScenarios);

    return newTestScenario;
  }

  Future<void> updateTestScenario(final TestScenario testScenario) async {
    final Isar isar = await ref.read(isarProvider.future);

    throw UnimplementedError();
  }
}
