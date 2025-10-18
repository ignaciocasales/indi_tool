import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/core/application/load_runner_provider.dart';
import 'package:indi_tool/core/application/repositories/test_cases_repository_provider.dart';
import 'package:indi_tool/core/application/repositories/test_results_repository_provider.dart';
import 'package:indi_tool/core/application/result_buffer_provider.dart';
import 'package:indi_tool/core/domain/models/test_case.dart';
import 'package:indi_tool/core/domain/models/test_result.dart';

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

final selectedTestResultProvider = StreamProvider<TestCaseResult?>((ref) {
  final testResultId = ref.watch(selectedTestResultIdProvider);
  if (testResultId == null) return Stream.value(null);
  final testCaseId = ref.watch(selectedTestCaseIdProvider);
  if (testCaseId == null) return Stream.value(null);
  final isRunning = ref.watch(isLoadRunnerRunningStateProvider);
  final allAsync = isRunning
      ? ref.watch(liveResultsProvider)
      : ref.watch(persistedResultsProvider(testCaseId));
  return allAsync.when(
    data: (results) =>
        Stream.value(results.firstWhereOrNull((r) => r.id == testResultId)),
    loading: () => Stream.value(null),
    error: (_, _) => Stream.value(null),
  );
});

class TestResultsFilters {
  const TestResultsFilters({
    this.query = '',
    this.successOnly = false,
    this.failureOnly = false,
    this.minMs,
    this.maxMs,
  });

  final String query;
  final bool successOnly;
  final bool failureOnly;
  final int? minMs;
  final int? maxMs;

  bool get anyActive =>
      query.trim().isNotEmpty ||
      successOnly ||
      failureOnly ||
      minMs != null ||
      maxMs != null;

  static const _unset = Object();

  TestResultsFilters copyWith({
    Object? query = _unset,
    Object? successOnly = _unset,
    Object? failureOnly = _unset,
    Object? minMs = _unset,
    Object? maxMs = _unset,
  }) {
    return TestResultsFilters(
      query: query == _unset ? this.query : query as String,
      successOnly: successOnly == _unset
          ? this.successOnly
          : successOnly as bool,
      failureOnly: failureOnly == _unset
          ? this.failureOnly
          : failureOnly as bool,
      minMs: minMs == _unset ? this.minMs : minMs as int?,
      maxMs: maxMs == _unset ? this.maxMs : maxMs as int?,
    );
  }

  static TestResultsFilters cleared() => const TestResultsFilters();
}

class TestResultsFiltersNotifier extends Notifier<TestResultsFilters> {
  @override
  TestResultsFilters build() => const TestResultsFilters();

  void setQuery(String query) {
    state = state.copyWith(query: query);
  }

  void setSuccessOnly(bool value) {
    state = state.copyWith(
      successOnly: value,
      failureOnly: value ? false : state.failureOnly,
    );
  }

  void setFailureOnly(bool value) {
    state = state.copyWith(
      failureOnly: value,
      successOnly: value ? false : state.successOnly,
    );
  }

  void replace(TestResultsFilters updated) {
    state = updated;
  }

  void clear() {
    state = TestResultsFilters.cleared();
  }
}

final testResultsFiltersProvider =
    NotifierProvider<TestResultsFiltersNotifier, TestResultsFilters>(
      TestResultsFiltersNotifier.new,
    );

final filteredTestResultsProvider = StreamProvider<List<TestCaseResult>>((ref) {
  final testCaseId = ref.watch(selectedTestCaseIdProvider);
  if (testCaseId == null) return Stream.value([]);
  final isRunning = ref.watch(isLoadRunnerRunningStateProvider);
  final allAsync = isRunning
      ? ref.watch(liveResultsProvider)
      : ref.watch(persistedResultsProvider(testCaseId));
  return allAsync.when(
    data: (results) {
      final filters = ref.watch(testResultsFiltersProvider);

      var iter = results.where((TestCaseResult r) => true);
      if (filters.query.trim().isNotEmpty) {
        final q = filters.query.toLowerCase();
        iter = iter.where(
          (TestCaseResult r) =>
              r.requestUrl.toLowerCase().contains(q) ||
              r.requestMethod.toLowerCase().contains(q) ||
              json.encode(r.responseHeaders).toLowerCase().contains(q),
        );
      }

      if (filters.successOnly && !filters.failureOnly) {
        iter = iter.where((TestCaseResult r) => r.isSuccessStatusCode);
      } else if (filters.failureOnly && !filters.successOnly) {
        iter = iter.where((TestCaseResult r) => !r.isSuccessStatusCode);
      }

      if (filters.minMs != null) {
        iter = iter.where(
          (TestCaseResult r) => r.responseDurationInMillis >= filters.minMs!,
        );
      }

      if (filters.maxMs != null) {
        iter = iter.where(
          (TestCaseResult r) => r.responseDurationInMillis <= filters.maxMs!,
        );
      }

      return Stream.value(iter.toList());
    },
    loading: () => Stream.value([]),
    error: (_, _) => Stream.value([]),
  );
});
