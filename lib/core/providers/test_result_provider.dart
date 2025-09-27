import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/models/test_case.dart';
import 'package:indi_tool/models/test_result.dart';
import 'package:indi_tool/services/load_runner.dart';

class TestResultsByCase extends Notifier<Map<String, TestCaseResults>> {
  @override
  Map<String, TestCaseResults> build() => <String, TestCaseResults>{};

  Future<TestCaseResults> runFor(TestCase testCase) async {
    final runner = LoadRunner();
    final results = await runner.run(testCase);
    state = {
      ...state,
      testCase.id: results,
    };
    return results;
  }

  TestCaseResults? getFor(String testCaseId) => state[testCaseId];

  void clearFor(String testCaseId) {
    final newMap = {...state};
    newMap.remove(testCaseId);
    state = newMap;
  }
}

final testResultsByCaseProvider = NotifierProvider<TestResultsByCase, Map<String, TestCaseResults>>(
  TestResultsByCase.new,
);
