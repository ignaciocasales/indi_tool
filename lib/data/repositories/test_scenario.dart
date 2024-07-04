import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:es_compression/zstd.dart';
import 'package:indi_tool/data/mapper/test_scenario.dart';
import 'package:indi_tool/data/source/database.dart';
import 'package:indi_tool/models/workspace/indi_http_header.dart';
import 'package:indi_tool/models/workspace/indi_http_param.dart';
import 'package:indi_tool/models/workspace/test_scenario.dart';

class TestScenarioRepository {
  const TestScenarioRepository(this._db);

  final DriftDb _db;

  Stream<List<TestScenario>> watchTestScenarioList() {
    return _db.managers.testScenarioTable.watch().map((d) {
      return TestScenarioMapper.fromEntries(d);
    });
  }

  Stream<TestScenario> watchTestScenario({required int scenarioId}) {
    return _db.managers.testScenarioTable
        .filter((f) => f.id(scenarioId))
        .watchSingle()
        .map((d) {
      return TestScenarioMapper.fromEntry(d);
    });
  }

  Future<int> createTestScenario({
    required final TestScenario testScenario,
  }) async {
    return await _db.managers.testScenarioTable.create(
      (o) => o(
        name: testScenario.name,
        description: testScenario.description,
        numberOfRequests: testScenario.numberOfRequests,
        threadPoolSize: testScenario.threadPoolSize,
        method: testScenario.request.method.name,
        url: testScenario.request.url,
        bodyType: testScenario.request.bodyType.name,
        body: Uint8List.fromList(zstd.encode(testScenario.request.body)),
        timeoutMillis: testScenario.request.timeoutMillis,
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
  }) async {
    return await _db.managers.testScenarioTable.replace(
      TestScenarioTableData(
        id: testScenario.id!,
        name: testScenario.name,
        description: testScenario.description,
        numberOfRequests: testScenario.numberOfRequests,
        threadPoolSize: testScenario.threadPoolSize,
        method: testScenario.request.method.name,
        url: testScenario.request.url,
        bodyType: testScenario.request.bodyType.name,
        body: Uint8List.fromList(zstd.encode(testScenario.request.body)),
        timeoutMillis: testScenario.request.timeoutMillis,
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
