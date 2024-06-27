import 'package:indi_tool/models/workspace/test_group.dart';
import 'package:indi_tool/models/workspace/test_scenario.dart';
import 'package:indi_tool/models/workspace/workspace.dart';
import 'package:indi_tool/providers/injection/dependency_prov.dart';
import 'package:indi_tool/providers/navigation/workspace_router_prov.dart';
import 'package:indi_tool/services/db/database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

part 'repository_prov.g.dart';

@riverpod
class WorkspaceRepository extends _$WorkspaceRepository {
  late final DriftDb db = ref.read(driftProvider);

  @override
  Stream<List<Workspace>> build() {
    return db.managers.workspaceTable.watch().map((tbl) {
      return tbl.map((data) {
        return Workspace(
          id: data.id,
          name: data.name,
          description: data.description,
        );
      }).toList();
    });
  }

  Future<int> createWorkspace(final Workspace workspace) async {
    return await db.managers.workspaceTable.create((o) => o(
          name: workspace.name,
          description: workspace.description,
        ));
  }

  void updateWorkspace(final Workspace workspace) async {
    await db.managers.workspaceTable.replace(WorkspaceTableData(
      id: workspace.id!,
      name: workspace.name,
      description: workspace.description,
    ));
  }

  void deleteWorkspace(final int id) async {
    await db.managers.workspaceTable.filter((f) => f.id(id)).delete();
  }
}

@riverpod
class TestGroupsRepository extends _$TestGroupsRepository {
  late final DriftDb db = ref.read(driftProvider);
  int? _workspaceId;

  @override
  Stream<List<TestGroup>> build() {
    _workspaceId = ref.watch(selectedWorkspaceProvider);

    if (_workspaceId == null) {
      return const Stream.empty();
    }

    var testGroupsStream = db.managers.testGroupTable
        .filter((f) => f.workspace.id(_workspaceId!))
        .watch();

    return testGroupsStream.switchMap((groups) {
      final idToGroup = {for (var group in groups) group.id: group};
      final ids = idToGroup.keys;

      return db.managers.testScenarioTable
          .filter((f) => f.testGroup.id.isIn(ids))
          .watch()
          .map((tbl) {
        final idToItems = <int, List<TestScenarioTableData>>{};

        for (final TestScenarioTableData item in tbl) {
          idToItems.putIfAbsent(item.testGroup, () => []).add(item);
        }

        return ids.map((id) {
          final List<TestScenario> scenarios = idToItems[id] != null
              ? idToItems[id]!.map((e) {
                  return TestScenario(
                    id: e.id,
                    name: e.name,
                    description: e.description,
                  );
                }).toList()
              : List<TestScenario>.empty();

          return TestGroup(
            id: id,
            name: idToGroup[id]!.name,
            description: idToGroup[id]!.description,
            testScenarios: scenarios,
          );
        }).toList();
      });
    });
  }

  Future<int> createTestGroup(final TestGroup testGroup) async {
    if (_workspaceId == null) {
      return -1;
    }

    return await db.managers.testGroupTable.create((o) => o(
          name: testGroup.name,
          description: testGroup.description,
          workspace: _workspaceId!,
        ));
  }

  void updateTestGroup(final TestGroup testGroup) {
    db.managers.testGroupTable.replace(TestGroupTableData(
      id: testGroup.id!,
      name: testGroup.name,
      description: testGroup.description,
      workspace: _workspaceId!,
    ));
  }

  void deleteTestGroup(final int id) async {
    await db.managers.testGroupTable.filter((f) => f.id(id)).delete();
  }
}

@riverpod
class TestGroupRepository extends _$TestGroupRepository {
  late final DriftDb db = ref.read(driftProvider);

  @override
  Stream<TestGroup> build(final int testGroupId) {
    return db.managers.testGroupTable
        .filter((f) => f.id(testGroupId))
        .watchSingle()
        .map((data) {
      return TestGroup(
        id: data.id,
        name: data.name,
        description: data.description,
      );
    });
  }
}

@riverpod
class TestScenariosRepository extends _$TestScenariosRepository {
  late final DriftDb db = ref.read(driftProvider);
  int? _testGroupId;

  @override
  Stream<List<TestScenario>> build({final int? id = -1}) {
    if (id == -1) {
      _testGroupId = ref.watch(selectedTestGroupProvider);
    } else {
      _testGroupId = id;
    }

    if (_testGroupId == null) {
      return Stream.empty();
    }

    return db.managers.testScenarioTable
        .filter((f) => f.testGroup.id(_testGroupId!))
        .watch()
        .map((tbl) {
      return tbl.map((data) {
        return TestScenario(
          id: data.id,
          name: data.name,
          description: data.description,
          numberOfRequests: data.numberOfRequests,
          threadPoolSize: data.threadPoolSize,
        );
      }).toList();
    });
  }

  Future<int> createTestScenario(final TestScenario testScenario) async {
    if (_testGroupId == null) {
      return -1;
    }

    return await db.managers.testScenarioTable.create((o) => o(
          name: testScenario.name,
          description: testScenario.description,
          testGroup: _testGroupId!,
          numberOfRequests: testScenario.numberOfRequests,
          threadPoolSize: testScenario.threadPoolSize,
        ));
  }

  void updateTestScenario(final TestScenario testScenario) async {
    await db.managers.testScenarioTable.replace(TestScenarioTableData(
      id: testScenario.id!,
      name: testScenario.name,
      description: testScenario.description,
      testGroup: _testGroupId!,
      numberOfRequests: testScenario.numberOfRequests,
      threadPoolSize: testScenario.threadPoolSize,
    ));
  }

  void deleteTestScenario(final int id) async {
    await db.managers.testScenarioTable.filter((f) => f.id(id)).delete();
  }
}

@riverpod
class TestScenarioRepository extends _$TestScenarioRepository {
  late final DriftDb db = ref.read(driftProvider);
  int? _testScenarioId;

  @override
  Stream<TestScenario> build({final int? id = -1}) {
    if (id == -1) {
      _testScenarioId = ref.watch(selectedTestScenarioProvider);
    } else {
      _testScenarioId = id;
    }

    if (_testScenarioId == null) {
      return const Stream.empty();
    }

    return db.managers.testScenarioTable
        .filter((f) => f.id(_testScenarioId!))
        .watchSingle()
        .map((data) {
      return TestScenario(
        id: data.id,
        name: data.name,
        description: data.description,
      );
    });
  }
}
