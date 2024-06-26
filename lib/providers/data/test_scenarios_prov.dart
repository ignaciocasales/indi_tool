import 'package:indi_tool/providers/data/test_groups_prov.dart';
import 'package:indi_tool/providers/injection/dependency_prov.dart';
import 'package:indi_tool/schema/test_group.dart';
import 'package:indi_tool/schema/test_scenario.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

part 'test_scenarios_prov.g.dart';

@riverpod
class TestScenarios extends _$TestScenarios {
  late final String _testGroupId;

  @override
  Future<List<TestScenario>> build(final String testGroupId) async {
    final Database db = await ref.watch(sqliteProvider.future);

    _testGroupId = testGroupId;

    return await _getAllTestScenarios(db, testGroupId);
  }

  Future<TestScenario> addScenario(final TestScenario scenario) async {
    final Database db = await ref.watch(sqliteProvider.future);

    await db.insert(
      TestScenario.tableName,
      scenario.toInsert(_testGroupId),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    state = AsyncValue.data(await _getAllTestScenarios(db, _testGroupId));

    return scenario;
  }

  Future<TestScenario> updateScenario(final TestScenario scenario) async {
    final Database db = await ref.watch(sqliteProvider.future);

    await db.update(
      TestScenario.tableName,
      scenario.toInsert(_testGroupId),
      where: 'id = ?',
      whereArgs: [scenario.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    state = AsyncValue.data(await _getAllTestScenarios(db, _testGroupId));

    return scenario;
  }

  void deleteTestScenario(final String id) async {
    final Database db = await ref.watch(sqliteProvider.future);

    await db.delete(
      TestScenario.tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    state = AsyncValue.data(await _getAllTestScenarios(db, _testGroupId));
  }

  Future<List<TestScenario>> _getAllTestScenarios(
    final Database db,
    final String testGroupId,
  ) async {
    return await db.query(
      TestScenario.tableName,
      where: 'test_group_id = ?',
      whereArgs: [testGroupId],
    ).then((v) {
      return v.map((e) => TestScenario.fromJson(e)).toList();
    });
  }
}

@riverpod
Future<TestScenario> testScenario(
  final TestScenarioRef ref,
  final String scenarioId,
) async {
  final List<TestGroup> groups = await ref.watch(testGroupsProvider.future);

  final TestScenario scenario = groups
      .map((group) => group.testScenarios)
      .expand((scenario) => scenario)
      .firstWhere((scenario) => scenario.id == scenarioId);

  return scenario;
}
