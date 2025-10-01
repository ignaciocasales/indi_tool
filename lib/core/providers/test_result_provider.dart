import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/experimental/persist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/core/providers/storage_provider.dart';
import 'package:indi_tool/core/providers/test_case_provider.dart';
import 'package:indi_tool/models/test_case.dart';
import 'package:indi_tool/models/test_result.dart';
import 'package:indi_tool/services/load_runner.dart';

class TestCaseResultsNotifier extends AsyncNotifier<List<TestCaseResults>> {
  StreamSubscription<TestCaseResult>? _sub;

  @override
  FutureOr<List<TestCaseResults>> build() async {
    await persist(
      ref.watch(storageProvider.future),
      key: 'test_case_results',
      options: const StorageOptions(
        cacheTime: StorageCacheTime.unsafe_forever, // Offline only.
      ),
      encode: (value) =>
          jsonEncode(value.map((e) => TestCaseResults.toJson(e)).toList()),
      decode: (json) => TestCaseResults.fromJsonArray(json),
    ).future;

    // If a state is persisted, we return it. Otherwise we return an empty list.
    return state.value ?? [];
  }

  Future<void> runFor(TestCase testCase) async {
    // cancel any previous subscription
    await _sub?.cancel();

    // Overwrite previous results for this test case and start clean
    final current = await future;
    final without = current.where((e) => e.testCaseId != testCase.id).toList();
    final fresh = TestCaseResults(testCaseId: testCase.id, results: []);
    state = AsyncData([...without, fresh]);

    final runner = LoadRunner();
    final stream = runner.runStream(testCase);

    _sub = stream.listen((partial) {
      final list = state.value ?? [];
      final idx = list.indexWhere((e) => e.testCaseId == testCase.id);
      if (idx == -1) return; // shouldn't happen
      final updatedEntry = list[idx].copyWith(results: [...list[idx].results, partial]);
      final updatedList = [...list];
      updatedList[idx] = updatedEntry;
      state = AsyncData(updatedList); // triggers UI + persistence
    });

    try {
      await _sub!.asFuture<void>(); // wait until stream closes
    } finally {
      await _sub?.cancel();
      _sub = null;
    }
  }
}

final testCaseResultsProvider = AsyncNotifierProvider<
    TestCaseResultsNotifier, List<TestCaseResults>>(TestCaseResultsNotifier.new);

final selectedTestResultsProvider = FutureProvider<TestCaseResults?>((ref) {
  final testCaseId = ref.watch(selectedTestCaseIdProvider);
  if (testCaseId == null) return null;

  final testCaseResults = ref.watch(testCaseResultsProvider).value;
  if (testCaseResults == null) return null;

  return testCaseResults
      .firstWhereOrNull((element) => element.testCaseId == testCaseId);
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

final selectedTestResultIdProvider = NotifierProvider<SelectedTestResultByIdNotifier, String?>(
  SelectedTestResultByIdNotifier.new,
);

final selectedTestResultProvider = Provider<TestCaseResult?>((ref) {
  final resultId = ref.watch(selectedTestResultIdProvider);
  if (resultId == null) return null;

  final testCaseResults = ref.watch(selectedTestResultsProvider).value;
  if (testCaseResults == null) return null;

  return testCaseResults.results.firstWhereOrNull((e) => e.id == resultId);
});