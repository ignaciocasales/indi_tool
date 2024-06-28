import 'package:indi_tool/data/repositories/indi_http_request.dart';
import 'package:indi_tool/data/repositories/test_group.dart';
import 'package:indi_tool/data/repositories/test_scenario.dart';
import 'package:indi_tool/data/repositories/workspace.dart';
import 'package:indi_tool/data/source/database.dart';
import 'package:indi_tool/models/workspace/indi_http_request.dart';
import 'package:indi_tool/models/workspace/test_group.dart';
import 'package:indi_tool/models/workspace/test_scenario.dart';
import 'package:indi_tool/models/workspace/workspace.dart';
import 'package:indi_tool/providers/di/di_prov.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repository_prov.g.dart';

@riverpod
WorkspaceRepository workspaceRepository(
  final WorkspaceRepositoryRef ref,
) {
  final DriftDb db = ref.watch(driftProvider);
  return WorkspaceRepository(db);
}

@riverpod
Stream<List<Workspace>> workspaceList(WorkspaceListRef ref) {
  return ref.watch(workspaceRepositoryProvider).watchWorkspaceList();
}

@riverpod
TestGroupRepository testGroupRepository(
  final TestGroupRepositoryRef ref,
) {
  final DriftDb db = ref.watch(driftProvider);
  return TestGroupRepository(db);
}

@riverpod
Stream<TestGroup> testGroup(
  final TestGroupRef ref, {
  required final int testGroupId,
}) {
  return ref
      .watch(testGroupRepositoryProvider)
      .watchTestGroup(groupId: testGroupId);
}

@riverpod
TestScenarioRepository testScenarioRepository(
  final TestScenarioRepositoryRef ref,
) {
  final DriftDb db = ref.watch(driftProvider);
  final IndiHttpRequestRepository indiHttpRequestRepository =
      ref.watch(indiHttpRequestRepositoryProvider);
  return TestScenarioRepository(db, indiHttpRequestRepository);
}

@riverpod
Stream<TestScenario> testScenario(
  final TestScenarioRef ref, {
  required final int scenarioId,
}) {
  return ref
      .watch(testScenarioRepositoryProvider)
      .watchTestScenarioWithRequest(scenarioId: scenarioId);
}

@riverpod
IndiHttpRequestRepository indiHttpRequestRepository(
  final IndiHttpRequestRepositoryRef ref,
) {
  final DriftDb db = ref.watch(driftProvider);
  return IndiHttpRequestRepository(db);
}

@riverpod
Stream<IndiHttpRequest> indiHttpRequest(
  final IndiHttpRequestRef ref, {
  required final int scenarioId,
}) {
  return ref
      .watch(indiHttpRequestRepositoryProvider)
      .watchHttpRequest(scenarioId: scenarioId);
}
