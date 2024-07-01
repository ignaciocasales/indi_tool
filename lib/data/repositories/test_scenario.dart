import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:es_compression/zstd.dart';
import 'package:indi_tool/data/mapper/test_scenario.dart';
import 'package:indi_tool/data/source/database.dart';
import 'package:indi_tool/models/workspace/indi_http_header.dart';
import 'package:indi_tool/models/workspace/indi_http_param.dart';
import 'package:indi_tool/models/workspace/test_scenario.dart';
import 'package:rxdart/transformers.dart';

class TestScenarioRepository {
  const TestScenarioRepository(this._db);

  final DriftDb _db;

  Stream<TestScenario> watchTestScenario({required int scenarioId}) {
    return _db.managers.testScenarioTable
        .filter((f) => f.id(scenarioId))
        .watchSingle()
        .map((d) {
      return TestScenarioMapper.fromEntry(d);
    }).onErrorResume((error, stackTrace) {
      print('error: $error');
      print('stackTrace: $stackTrace');
      return const Stream.empty();
    });
  }

  Future<int> createTestScenario({
    required final TestScenario testScenario,
    required final int testGroupId,
  }) async {
    return await _db.managers.testScenarioTable.create(
      (o) => o(
        name: testScenario.name,
        description: testScenario.description,
        testGroup: testGroupId,
        numberOfRequests: testScenario.numberOfRequests,
        threadPoolSize: testScenario.threadPoolSize,
        method: testScenario.request.method.name,
        body: testScenario.request.body,
        url: testScenario.request.url,
        httpParams: Uint8List.fromList(zstd.encode(utf8.encode(jsonEncode(
            testScenario.request.parameters
                .map((p) => IndiHttpParam.toJson(p))
                .toList())))),
        httpHeaders: Uint8List.fromList(zstd.encode(utf8.encode(jsonEncode(
            testScenario.request.headers
                .map((p) => IndiHttpHeader.toJson(p))
                .toList())))),
      ),
    );
  }

  Future<bool> updateTestScenario({
    required final TestScenario testScenario,
    required final int testGroupId,
  }) async {
    return await _db.managers.testScenarioTable.replace(
      TestScenarioTableData(
        id: testScenario.id!,
        name: testScenario.name,
        description: testScenario.description,
        testGroup: testGroupId,
        numberOfRequests: testScenario.numberOfRequests,
        threadPoolSize: testScenario.threadPoolSize,
        method: testScenario.request.method.name,
        body: testScenario.request.body,
        url: testScenario.request.url,
        httpParams: Uint8List.fromList(zstd.encode(utf8.encode(jsonEncode(
            testScenario.request.parameters
                .map((p) => IndiHttpParam.toJson(p))
                .toList())))),
        httpHeaders: Uint8List.fromList(zstd.encode(utf8.encode(jsonEncode(
            testScenario.request.headers
                .map((p) => IndiHttpHeader.toJson(p))
                .toList())))),
      ),
    );
  }

  Future<int> deleteTestScenario(final int scenarioId) async {
    return await _db.managers.testScenarioTable
        .filter((f) => f.id(scenarioId))
        .delete();
  }
}
