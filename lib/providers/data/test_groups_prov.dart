import 'package:indi_tool/providers/data/workspace_prov.dart';
import 'package:indi_tool/providers/data/workspaces_prov.dart';
import 'package:indi_tool/providers/injection/dependency_prov.dart';
import 'package:indi_tool/schema/test_group.dart';
import 'package:indi_tool/schema/workspace.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'test_groups_prov.g.dart';

@riverpod
class TestGroups extends _$TestGroups {
  @override
  Future<List<TestGroup>> build() async {
    final int id = ref.read(selectedWorkspaceProvider)!;

    final Isar isar = await ref.read(isarProvider.future);

    return isar.workspaces.where().idEqualTo(id).findFirst()?.testGroups ??
        List.empty();
  }

  Future<TestGroup> getTestGroup(final String testGroupId) async {
    final Isar isar = await ref.read(isarProvider.future);

    final List<Workspace> workspaces = isar.workspaces.where().findAll();

    final TestGroup testGroup = workspaces
        .map((e) => e.testGroups)
        .expand((e) => e)
        .firstWhere((e) => e.id == testGroupId);

    return testGroup;
  }

  Future<TestGroup> addTestGroup(final Workspace workspace) async {
    final TestGroup testGroup = TestGroup.newWith(
      name: 'New Test Group',
    );

    workspace.testGroups.add(testGroup);

    await ref.read(workspacesProvider.notifier).updateWorkspace(workspace);

    state = AsyncValue.data(workspace.testGroups);

    return testGroup;
  }

  Future<void> updateTestGroup(final TestGroup testGroup) async {
    final Isar isar = await ref.read(isarProvider.future);

    matchesGroupId(q) => q.id == testGroup.id;

    // TODO: I could not make filters work.
    final List<Workspace> workspaces = isar.workspaces.where().findAll();
    final Workspace workspace = workspaces
        .where((q) => q.testGroups.indexWhere(matchesGroupId) != -1)
        .first;

    // Update the test group
    workspace.testGroups[workspace.testGroups.indexWhere(matchesGroupId)] =
        testGroup;

    await ref.read(workspacesProvider.notifier).updateWorkspace(workspace);

    state = AsyncValue.data(workspace.testGroups);
  }
}
