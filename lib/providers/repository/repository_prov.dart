import 'package:indi_tool/data/repositories/test_scenario.dart';
import 'package:indi_tool/data/source/database.dart';
import 'package:indi_tool/models/workspace/test_scenario.dart';
import 'package:indi_tool/providers/di/di_prov.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repository_prov.g.dart';

@riverpod
TestScenarioRepository testScenarioRepository(
  final TestScenarioRepositoryRef ref,
) {
  final DriftDb db = ref.watch(driftProvider);
  return TestScenarioRepository(db);
}

@riverpod
Stream<TestScenario> testScenario(
  final TestScenarioRef ref, {
  required final int scenarioId,
}) {
  return ref
      .watch(testScenarioRepositoryProvider)
      .watchTestScenario(scenarioId: scenarioId);
}
