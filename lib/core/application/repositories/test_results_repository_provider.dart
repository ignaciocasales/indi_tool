import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/core/db/database.dart';
import 'package:indi_tool/core/domain/models/test_result.dart';
import 'package:uuid/uuid.dart';

class TestResultsRepository {
  TestResultsRepository();

  final DriftDb _db = DriftDbInstance.get;

  Stream<List<TestCaseResult>> watchAll({required final String testCaseId}) {
    return (_db.select(_db.testCaseResultsTable)
          ..where((tbl) => tbl.testCaseId.equals(testCaseId)))
        .watch()
        .map((rows) {
          return rows.map((row) => TestCaseResults.fromData(row)).toList();
        })
        .map((List<TestCaseResults> results) {
          return results.expand((e) => e.results).toList();
        });
  }

  Stream<TestCaseResult> watch({
    required final String testCaseId,
    required final String testResultId,
  }) {
    return (_db.select(_db.testCaseResultsTable)
          ..where((tbl) => tbl.testCaseId.equals(testCaseId)))
        .watchSingle()
        .map((row) => TestCaseResults.fromData(row))
        .map(
          (testCaseResults) => testCaseResults.results.firstWhere(
            (result) => result.id == testResultId,
          ),
        );
  }

  Future<void> save({
    required final String testCaseId,
    required final List<TestCaseResult> results,
  }) async {
    final exists = await (_db.select(
      _db.testCaseResultsTable,
    )..where((tbl) => tbl.testCaseId.equals(testCaseId))).getSingleOrNull();
    if (exists != null) {
      final entity = TestCaseResults.fromData(
        exists,
      ).copyWith(results: results);
      final entry = TestCaseResultsTableCompanion(
        testCaseId: Value(UuidValue.fromString(entity.testCaseId)),
        resultsJson: Value(
          Uint8List.fromList(
            utf8.encode(jsonEncode(TestCaseResult.toJsonArray(entity.results))),
          ),
        ),
        updatedAt: Value(DateTime.now()),
      );
      // Update by testCaseId because id is different for each save.
      await (_db.update(
        _db.testCaseResultsTable,
      )..where((tbl) => tbl.testCaseId.equals(testCaseId))).write(entry);
    } else {
      final entity = TestCaseResults(testCaseId: testCaseId, results: results);
      final entry = TestCaseResultsTableCompanion(
        id: Value(UuidValue.fromString(entity.id)),
        testCaseId: Value(UuidValue.fromString(entity.testCaseId)),
        resultsJson: Value(
          Uint8List.fromList(
            utf8.encode(jsonEncode(TestCaseResult.toJsonArray(entity.results))),
          ),
        ),
        createdAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      );
      await (_db.into(_db.testCaseResultsTable).insert(entry));
    }
  }
}

final testResultsRepositoryProvider = Provider<TestResultsRepository>(
  (ref) => TestResultsRepository(),
);

final persistedResultsProvider =
    StreamProvider.family<List<TestCaseResult>, String>((ref, testCaseId) {
      final repo = ref.watch(testResultsRepositoryProvider);
      return repo.watchAll(testCaseId: testCaseId);
    });
