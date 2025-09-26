import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/experimental/persist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/core/providers/storage_provider.dart';
import 'package:indi_tool/models/test_case.dart';

class TestCaseList extends AsyncNotifier<List<TestCase>> {
  @override
  FutureOr<List<TestCase>> build() async {
    await persist(
      ref.watch(storageProvider.future),
      key: 'test_case_list',
      options: const StorageOptions(
        cacheTime: StorageCacheTime(Duration(days: 1)),
      ),
      encode: (value) =>
          jsonEncode(value.map((e) => TestCase.toJson(e)).toList()),
      decode: (json) => TestCase.fromJsonArray(json),
    ).future;

    // If a state is persisted, we return it. Otherwise we return an empty list.
    return state.value ?? [];
  }

  Future<void> add(TestCase testCase) async {
    state = AsyncData([...await future, testCase]);
  }

  Future<void> removeById(String id) async {
    final current = await future;
    state = AsyncData(current.where((e) => e.id != id).toList());
  }

  Future<void> updateTestCase(TestCase updated) async {
    final current = await future;
    state = AsyncData(
      current.map((e) => e.id == updated.id ? updated : e).toList(),
    );
  }
}

final testCaseListProvider =
    AsyncNotifierProvider<TestCaseList, List<TestCase>>(TestCaseList.new);

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

final selectedTestCaseIdProvider = NotifierProvider<SelectedTestCaseId, String?>(
  SelectedTestCaseId.new,
);

final selectedTestCaseProvider = Provider<TestCase?>((ref) {
  final listAsync = ref.watch(testCaseListProvider);
  final id = ref.watch(selectedTestCaseIdProvider);

  final list = listAsync.value;
  if (list == null || id == null) return null;
  return list.firstWhereOrNull((e) => e.id == id);
});

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
