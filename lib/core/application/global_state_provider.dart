import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/core/application/repositories/test_cases_repository_provider.dart';
import 'package:indi_tool/core/application/result_buffer_provider.dart';
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

class SelectedTestCaseIdNotifier extends Notifier<String?> {
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
    NotifierProvider<SelectedTestCaseIdNotifier, String?>(
      SelectedTestCaseIdNotifier.new,
    );

class SelectedTestResultIdNotifier extends Notifier<String?> {
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
    NotifierProvider<SelectedTestResultIdNotifier, String?>(
      SelectedTestResultIdNotifier.new,
    );

final testCasesProvider = StreamProvider<List<TestCase>>((ref) {
  final repo = ref.read(testCasesRepositoryProvider);
  return repo.watchAll();
});

final selectedTestCaseProvider = StreamProvider<TestCase?>((ref) {
  final repo = ref.read(testCasesRepositoryProvider);
  final id = ref.watch(selectedTestCaseIdProvider);
  if (id == null) return Stream.value(null);
  return repo.watch(id: id);
});

// final selectedTestResultsProvider = StreamProvider<List<TestCaseResult>?>((
//   ref,
// ) {
//   // final repo = ref.read(testResultsRepositoryProvider);
//   // final testCaseId = ref.watch(selectedTestCaseIdProvider);
//   // if (testCaseId == null) return Stream.value(null);
//   // return repo.watchAll(testCaseId);
//   final buffer = ref.watch(resultBufferProvider);
//   return buffer.stream;
// });

final selectedTestResultProvider = StreamProvider<TestCaseResult?>((ref) {
  final live = ref.watch(liveResultsProvider);
  // final testCaseId = ref.watch(selectedTestCaseIdProvider);
  // if (testCaseId == null) return Stream.value(null);
  final testResultId = ref.watch(selectedTestResultIdProvider);
  if (testResultId == null) return Stream.value(null);
  return live.when(
    data: (results) =>
        Stream.value(results.firstWhereOrNull((r) => r.id == testResultId)),
    loading: () => Stream.value(null),
    error: (_, _) => Stream.value(null),
  );
});
