import 'package:indi_tool/data/mapper/test_scenario.dart';
import 'package:indi_tool/data/repositories/indi_http_request.dart';
import 'package:indi_tool/data/source/database.dart';
import 'package:indi_tool/models/workspace/test_scenario.dart';
import 'package:rxdart/rxdart.dart';

class TestScenarioRepository {
  const TestScenarioRepository(this._db, this._indiHttpRequestRepository);

  final DriftDb _db;
  final IndiHttpRequestRepository _indiHttpRequestRepository;

  Stream<TestScenario> watchTestScenarioWithRequest({required int scenarioId}) {
    return _db.managers.testScenarioTable
        .filter((f) => f.id(scenarioId))
        .watchSingle()
        .switchMap((d) {
      final TestScenario scenario = TestScenarioMapper.fromEntry(d);
      return _indiHttpRequestRepository
          .watchHttpRequest(scenarioId: scenarioId)
          .map((request) => scenario.copyWith(request: request));
    });
    return _indiHttpRequestRepository
        .watchHttpRequest(scenarioId: scenarioId)
        .switchMap((request) {
      return _db.managers.testScenarioTable
          .filter((f) => f.id(scenarioId))
          .watchSingle()
          .map((d) {
        final TestScenario scenario = TestScenarioMapper.fromEntry(d);
        return scenario.copyWith(request: request);
      });
    });
    return _db.managers.testScenarioTable
        .filter((f) => f.id(scenarioId))
        .watchSingle()
        .map((d) => TestScenarioMapper.fromEntry(d));
  }

  Future<int> createTestScenario({
    required final TestScenario testScenario,
    required final int testGroupId,
  }) async {
    return _db.transaction(() async {
      final int scenarioId =
          await _db.managers.testScenarioTable.create((o) => o(
                name: testScenario.name,
                description: testScenario.description,
                testGroup: testGroupId,
                numberOfRequests: testScenario.numberOfRequests,
                threadPoolSize: testScenario.threadPoolSize,
              ));

      final int requestId =
          await _db.managers.indiHttpRequestTable.create((o) => o(
                method: testScenario.request.method.name,
                url: testScenario.request.url,
                body: testScenario.request.body,
                testScenario: scenarioId,
              ));

      await _db.managers.indiHttpParamTable.bulkCreate((o) {
        return testScenario.request.parameters
            .map((p) => o(
                  key: p.key,
                  value: p.value,
                  description: p.description,
                  enabled: p.enabled,
                  indiHttpRequest: requestId,
                ))
            .toList();
      });

      await _db.managers.indiHttpHeaderTable.bulkCreate((o) {
        return testScenario.request.headers
            .map((h) => o(
                  key: h.key,
                  value: h.value,
                  description: h.description,
                  enabled: h.enabled,
                  indiHttpRequest: requestId,
                ))
            .toList();
      });

      return scenarioId;
    });
  }

  Future<bool> updateTestScenario({
    required final TestScenario testScenario,
    required final int testGroupId,
  }) async {
    return _db.transaction(() async {
      final bool updated =
          await _db.managers.testScenarioTable.replace(TestScenarioTableData(
        id: testScenario.id!,
        name: testScenario.name,
        description: testScenario.description,
        testGroup: testGroupId,
        numberOfRequests: testScenario.numberOfRequests,
        threadPoolSize: testScenario.threadPoolSize,
      ));

      await _db.managers.indiHttpRequestTable.replace(
        IndiHttpRequestTableData(
          id: testScenario.request.id!,
          method: testScenario.request.method.name,
          url: testScenario.request.url,
          body: testScenario.request.body,
          testScenario: testScenario.id!,
        ),
      );

      var params = await _db.managers.indiHttpParamTable
          .filter((f) => f.id
              .isIn(testScenario.request.parameters.map((p) => p.id!).toList()))
          .get();
      params = params.map((old) {
        var parameter =
            testScenario.request.parameters.firstWhere((p) => p.id == old.id);
        return IndiHttpParamTableData(
          id: old.id,
          key: parameter.key,
          value: parameter.value,
          enabled: parameter.enabled,
          description: parameter.description,
          indiHttpRequest: testScenario.request.id!,
        );
      }).toList();
      await _db.managers.indiHttpParamTable.bulkReplace(params);

      var headers = await _db.managers.indiHttpHeaderTable
          .filter((f) => f.id
              .isIn(testScenario.request.headers.map((h) => h.id!).toList()))
          .get();
      headers = headers.map((old) {
        var header =
            testScenario.request.headers.firstWhere((h) => h.id == old.id);
        return IndiHttpHeaderTableData(
          id: old.id,
          key: header.key,
          value: header.value,
          enabled: header.enabled,
          description: header.description,
          indiHttpRequest: testScenario.request.id!,
        );
      }).toList();
      await _db.managers.indiHttpHeaderTable.bulkReplace(headers);

      return updated;
    });
  }

  Future<int> deleteTestScenario(final int scenarioId) async {
    return await _db.managers.testScenarioTable
        .filter((f) => f.id(scenarioId))
        .delete();
  }
}
