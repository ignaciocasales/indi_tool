import 'package:indi_tool/data/mapper/test_group.dart';
import 'package:indi_tool/data/source/database.dart';
import 'package:indi_tool/models/workspace/test_group.dart';
import 'package:indi_tool/models/workspace/test_scenario.dart';
import 'package:rxdart/transformers.dart';

class TestGroupRepository {
  const TestGroupRepository(this._db);

  final DriftDb _db;

  Stream<TestGroup> watchTestGroup({
    required final int groupId,
  }) {
    return _db.managers.testGroupTable
        .filter((f) => f.id(groupId))
        .watchSingle()
        .map((d) => TestGroupMapper.fromEntry(d));
  }

  Stream<List<TestGroup>> watchTestGroupsWithScenarioList({
    required final int workspaceId,
  }) {
    final testGroupsStream = _db.managers.testGroupTable
        .filter((f) => f.workspace.id(workspaceId))
        .watch();

    return testGroupsStream.switchMap((groups) {
      final idToGroup = {for (var group in groups) group.id: group};
      final ids = idToGroup.keys;

      return _db.managers.testScenarioTable
          .filter((f) => f.testGroup.id.isIn(ids))
          .watch()
          .map((tbl) {
        final idToItems = <int, List<TestScenarioTableData>>{};

        for (final TestScenarioTableData item in tbl) {
          idToItems.putIfAbsent(item.testGroup, () => []).add(item);
        }

        return ids.map((groupId) {
          final List<TestScenario> scenarios = idToItems[groupId] != null
              ? idToItems[groupId]!.map(
                  (e) {
                    return TestScenario(
                      id: e.id,
                      name: e.name,
                      description: e.description,
                    );
                  },
                ).toList()
              : List<TestScenario>.empty();

          return TestGroup(
            id: groupId,
            name: idToGroup[groupId]!.name,
            description: idToGroup[groupId]!.description,
            testScenarios: scenarios,
          );
        }).toList();
      });
    });
  }

  Future<int> createTestGroup({
    required final TestGroup testGroup,
    required final int workspaceId,
  }) async {
    return await _db.managers.testGroupTable.create((o) => o(
          name: testGroup.name,
          description: testGroup.description,
          workspace: workspaceId,
        ));
  }

  Future<bool> updateTestGroup({
    required final TestGroup testGroup,
    required final int workspaceId,
  }) async {
    return await _db.managers.testGroupTable.replace(TestGroupTableData(
      id: testGroup.id!,
      name: testGroup.name,
      description: testGroup.description,
      workspace: workspaceId,
    ));
  }

  Future<int> deleteTestGroup(final int groupId) async {
    return await _db.managers.testGroupTable
        .filter((f) => f.id(groupId))
        .delete();
  }
}
