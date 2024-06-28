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

// @riverpod
// class TestScenariosRepository extends _$TestScenariosRepository {
//   late final DriftDb db = ref.read(driftProvider);
//   int? _testGroupId;
//
//   @override
//   Stream<List<TestScenario>> build({final int? id = -1}) {
//     if (id == -1) {
//       _testGroupId = ref.watch(selectedTestGroupProvider);
//     } else {
//       _testGroupId = id;
//     }
//
//     if (_testGroupId == null) {
//       return const Stream.empty();
//     }
//
//     return db.managers.testScenarioTable
//         .filter((f) => f.testGroup.id(_testGroupId!))
//         .watch()
//         .map((tbl) {
//       return tbl.map((data) {
//         return TestScenario(
//           id: data.id,
//           name: data.name,
//           description: data.description,
//           numberOfRequests: data.numberOfRequests,
//           threadPoolSize: data.threadPoolSize,
//         );
//       }).toList();
//     });
//   }
// }

// @riverpod
// class TestScenarioRepository extends _$TestScenarioRepository {
//   late final DriftDb db = ref.read(driftProvider);
//
//   @override
//   Stream<TestScenario> build({required final int id}) {
//     return db.managers.testScenarioTable
//         .filter((f) => f.id(id))
//         .watchSingle()
//         .switchMap((scenario) {
//       // TestScenario(
//       //   id: data.id,
//       //   name: data.name,
//       //   description: data.description,
//       // );
//       return Rx.combineLatest3(
//         db.managers.indiHttpRequestTable.filter((f) => f.id(id)).watchSingle(),
//         db.managers.indiHttpParamTable
//             .filter((f) => f.indiHttpRequest.id(id))
//             .watch(),
//         db.managers.indiHttpHeaderTable
//             .filter((f) => f.indiHttpRequest.id(id))
//             .watch(),
//         (
//           IndiHttpRequestTableData request,
//           List<IndiHttpParamTableData> params,
//           List<IndiHttpHeaderTableData> headers,
//         ) {
//           return TestScenario(
//             id: scenario.id,
//             name: scenario.name,
//             description: scenario.description,
//             request: IndiHttpRequest(
//               id: request.id,
//               method: HttpMethod.fromString(request.method),
//               url: request.url,
//               body: request.body,
//               parameters: params.map((e) {
//                 return IndiHttpParam(
//                   id: e.id,
//                   key: e.key,
//                   value: e.value,
//                   enabled: e.enabled,
//                   description: e.description,
//                 );
//               }).toList(),
//               headers: headers.map((e) {
//                 return IndiHttpHeader(
//                   id: e.id,
//                   key: e.key,
//                   value: e.value,
//                   enabled: e.enabled,
//                   description: e.description,
//                 );
//               }).toList(),
//             ),
//           );
//         },
//       );
//     });
//   }
// }

// @riverpod
// class IndiHttpRequestRepository extends _$IndiHttpRequestRepository {
//   late final DriftDb db = ref.read(driftProvider);
//
//   @override
//   Stream<IndiHttpRequest> build({required final int id}) {
//     return Rx.combineLatest3(
//       db.managers.indiHttpRequestTable.filter((f) => f.id(id)).watchSingle(),
//       db.managers.indiHttpParamTable
//           .filter((f) => f.indiHttpRequest.id(id))
//           .watch(),
//       db.managers.indiHttpHeaderTable
//           .filter((f) => f.indiHttpRequest.id(id))
//           .watch(),
//       (
//         IndiHttpRequestTableData request,
//         List<IndiHttpParamTableData> params,
//         List<IndiHttpHeaderTableData> headers,
//       ) {
//         return IndiHttpRequest(
//           id: request.id,
//           method: HttpMethod.fromString(request.method),
//           url: request.url,
//           body: request.body,
//           parameters: params.map((e) {
//             return IndiHttpParam(
//               id: e.id,
//               key: e.key,
//               value: e.value,
//               enabled: e.enabled,
//               description: e.description,
//             );
//           }).toList(),
//           headers: headers.map((e) {
//             return IndiHttpHeader(
//               id: e.id,
//               key: e.key,
//               value: e.value,
//               enabled: e.enabled,
//               description: e.description,
//             );
//           }).toList(),
//         );
//       },
//     );
//   }
// }
