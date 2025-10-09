import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/core/db/database.dart';
import 'package:indi_tool/core/domain/models/test_result.dart';

class TestResultsRepository {
  TestResultsRepository();

  final DriftDb _db = DriftDbInstance.get;

  Stream<List<TestCaseResult>> watchAll(String testCaseId) {
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
}

final testResultsRepositoryProvider = Provider<TestResultsRepository>(
  (ref) => TestResultsRepository(),
);
