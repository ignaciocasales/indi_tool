import 'package:indi_tool/providers/data/test_scenarios_prov.dart';
import 'package:indi_tool/providers/injection/dependency_prov.dart';
import 'package:indi_tool/providers/navigation/workspace_router_prov.dart';
import 'package:indi_tool/schema/test_group.dart';
import 'package:indi_tool/schema/test_scenario.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

part 'test_groups_prov.g.dart';

@riverpod
class TestGroups extends _$TestGroups {
  late String? _workspaceId;

  @override
  Future<List<TestGroup>> build() async {
    final Database db = await ref.watch(sqliteProvider.future);

    final String? workspaceId = ref.watch(selectedWorkspaceProvider);

    if (workspaceId == null) {
      _workspaceId = null;
      return [];
    }

    _workspaceId = workspaceId;

    return await _getAllTestGroups(db, workspaceId);
  }

  Future<TestGroup> addGroup(final TestGroup group) async {
    final Database db = await ref.watch(sqliteProvider.future);

    if (_workspaceId == null) {
      throw StateError('No workspace selected');
    }

    await db.insert(
      TestGroup.tableName,
      group.toInsert(_workspaceId!),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    state = AsyncValue.data(await _getAllTestGroups(db, _workspaceId!));

    return group;
  }

  Future<TestGroup> getGroup(final String id) async {
    final Database db = await ref.watch(sqliteProvider.future);

    return await db.query(
      TestGroup.tableName,
      where: 'id = ?',
      whereArgs: [id],
    ).then((v) {
      return TestGroup.fromJson(v.first);
    });
  }

  Future<void> updateTestGroup(final TestGroup testGroup) async {
    final Database db = await ref.watch(sqliteProvider.future);

    if (_workspaceId == null) {
      throw StateError('No workspace selected');
    }

    await db.update(
      TestGroup.tableName,
      testGroup.toInsert(_workspaceId!),
      where: 'id = ?',
      whereArgs: [testGroup.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    state = AsyncValue.data(await _getAllTestGroups(db, _workspaceId!));
  }

  void deleteGroup(final String id) async {
    final Database db = await ref.watch(sqliteProvider.future);

    if (_workspaceId == null) {
      throw StateError('No workspace selected');
    }

    await db.delete(
      TestGroup.tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    state = AsyncValue.data(await _getAllTestGroups(db, _workspaceId!));
  }

  Future<List<TestGroup>> _getAllTestGroups(
    final Database db,
    final String id,
  ) async {
    // return await db.transaction((txn) async {
    //   final groups = await txn.query(
    //     TestGroup.tableName,
    //     where: 'workspace_id = ?',
    //     whereArgs: [id],
    //   ).then((v) => v.map((e) => TestGroup.fromJson(e)).toList());
    //
    //   for (final group in groups) {
    //     final scenarios = await txn.query(
    //       'test_scenarios',
    //       where: 'test_group_id = ?',
    //       whereArgs: [group.id],
    //     ).then((v) => v.map((e) => TestScenario.fromJson(e)).toList());
    //
    //     groups[groups.indexWhere((e) => e.id == group.id)] =
    //         group.copyWith(testScenarios: scenarios);
    //   }
    //
    //   return groups;
    // });

    final groups = await db.query(
      TestGroup.tableName,
      where: 'workspace_id = ?',
      whereArgs: [id],
    ).then((v) => v.map((e) => TestGroup.fromJson(e)).toList());

    for (final group in groups) {
      final scenarios = await _getAllTestScenarios(group.id);

      groups[groups.indexWhere((e) => e.id == group.id)] =
          group.copyWith(testScenarios: scenarios);
    }

    return groups;
  }

  Future<List<TestScenario>> _getAllTestScenarios(
      final String testGroupId) async {
    final List<TestScenario> scenarios =
        await ref.watch(testScenariosProvider(testGroupId).future);

    return scenarios;
  }
}

@riverpod
Future<TestGroup> testGroup(
  final TestGroupRef ref,
  final String groupId,
) async {
  final List<TestGroup> groups = await ref.watch(testGroupsProvider.future);

  final TestGroup group = groups.firstWhere(
    (group) => group.id == groupId,
  );

  return group;
}
