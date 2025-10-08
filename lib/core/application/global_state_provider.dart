import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/core/domain/models/test_case.dart';
import 'package:indi_tool/core/domain/models/test_result.dart';

class IsTestCaseRunning extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void setRunning(bool isRunning) {
    state = isRunning;
  }
}

final isTestCaseRunningProvider = NotifierProvider<IsTestCaseRunning, bool>(
  IsTestCaseRunning.new,
);

class SelectedTestCaseId extends Notifier<String?> {
  @override
  String? build() {
    return null;
  }

  void set(String id) {
    state = id;
  }

  void clear() {
    state = null;
  }
}

final selectedTestCaseIdProvider =
    NotifierProvider<SelectedTestCaseId, String?>(SelectedTestCaseId.new);

final selectedTestCaseProvider = Provider<TestCase?>((ref) {
  final listAsync = ref.watch(testCaseListProvider);
  final id = ref.watch(selectedTestCaseIdProvider);

  final list = listAsync.value;
  if (list == null || id == null) return null;
  return list.firstWhereOrNull((e) => e.id == id);
});

final selectedTestResultsProvider = FutureProvider<TestCaseResults?>((ref) {
  final testCaseId = ref.watch(selectedTestCaseIdProvider);
  if (testCaseId == null) return null;

  final testCaseResults = ref.watch(testCaseResultsProvider).value;
  if (testCaseResults == null) return null;

  return testCaseResults.firstWhereOrNull(
    (element) => element.testCaseId == testCaseId,
  );
});

class SelectedTestResultByIdNotifier extends Notifier<String?> {
  @override
  String? build() {
    return null;
  }

  void set(String id) {
    state = id;
  }

  void clear() {
    state = null;
  }
}

final selectedTestResultIdProvider =
    NotifierProvider<SelectedTestResultByIdNotifier, String?>(
      SelectedTestResultByIdNotifier.new,
    );

final selectedTestResultProvider = Provider<TestCaseResult?>((ref) {
  final resultId = ref.watch(selectedTestResultIdProvider);
  if (resultId == null) return null;

  final testCaseResults = ref.watch(selectedTestResultsProvider).value;
  if (testCaseResults == null) return null;

  return testCaseResults.results.firstWhereOrNull((e) => e.id == resultId);
});
