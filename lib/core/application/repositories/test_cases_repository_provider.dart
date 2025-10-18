import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/core/db/database.dart';
import 'package:indi_tool/core/domain/models/test_case.dart';
import 'package:uuid/uuid.dart';

class TestCasesRepository {
  TestCasesRepository();

  final DriftDb _db = DriftDbInstance.get;

  Stream<List<TestCase>> watchAll() {
    return (_db.select(_db.testCasesTable)).watch().map(
      (rows) => rows.map((row) => TestCase.fromData(row)).toList(),
    );
  }

  Stream<TestCase> watch({required final String id}) {
    return (_db.select(_db.testCasesTable)..where((tbl) => tbl.id.equals(id)))
        .watchSingle()
        .map((row) => TestCase.fromData(row));
  }

  Future<String> insert({required final TestCase testCase}) async {
    final uuid = const Uuid().v4();
    final entry = TestCasesTableCompanion(
      id: Value(UuidValue.fromString(uuid)),
      name: Value(testCase.name),
      description: Value(testCase.description),
      httpMethod: Value(testCase.httpMethod),
      httpUrl: Value(testCase.httpUrl),
      httpBody: Value(Uint8List.fromList(utf8.encode(testCase.httpBody))),
      httpTimeoutInMillis: Value(testCase.httpTimeoutInMillis),
      httpHeaders: Value(
        Uint8List.fromList(utf8.encode(jsonEncode(testCase.httpHeaders))),
      ),
      httpParams: Value(
        Uint8List.fromList(utf8.encode(jsonEncode(testCase.httpParams))),
      ),
      numberOfRequests: Value(testCase.numberOfRequests),
      numberOfConcurrentUsers: Value(testCase.numberOfConcurrentUsers),
      createdAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    );
    await (_db.into(_db.testCasesTable).insert(entry));
    return uuid;
  }

  Future<int> delete({required final String id}) async {
    return await _db.transaction(() async {
      final get = await (_db.select(
        _db.testCasesTable,
      )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
      if (get == null) return 0;

      var i = await (_db.delete(
        _db.testCasesTable,
      )..where((tbl) => tbl.id.equals(id))).go();

      var j = await (_db.delete(
        _db.testCaseResultsTable,
      )..where((tbl) => tbl.testCaseId.equals(id))).go();

      return i + j;
    });
  }

  void update({required final TestCase testCase}) {
    final entry = TestCasesTableCompanion(
      name: Value(testCase.name),
      description: Value(testCase.description),
      httpMethod: Value(testCase.httpMethod),
      httpUrl: Value(testCase.httpUrl),
      httpBody: Value(Uint8List.fromList(utf8.encode(testCase.httpBody))),
      httpTimeoutInMillis: Value(testCase.httpTimeoutInMillis),
      httpHeaders: Value(
        Uint8List.fromList(
          utf8.encode(
            jsonEncode(
              testCase.httpHeaders
                  .map((h) => TestCaseHeader.toJson(h))
                  .toList(),
            ),
          ),
        ),
      ),
      httpParams: Value(
        Uint8List.fromList(
          utf8.encode(
            jsonEncode(
              testCase.httpParams.map((p) => TestCaseParam.toJson(p)).toList(),
            ),
          ),
        ),
      ),
      numberOfRequests: Value(testCase.numberOfRequests),
      numberOfConcurrentUsers: Value(testCase.numberOfConcurrentUsers),
      updatedAt: Value(DateTime.now()),
    );
    (_db.update(
      _db.testCasesTable,
    )..where((tbl) => tbl.id.equals(testCase.id))).write(entry);
  }
}

final testCasesRepositoryProvider = Provider<TestCasesRepository>(
  (ref) => TestCasesRepository(),
);
