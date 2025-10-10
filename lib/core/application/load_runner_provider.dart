import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/core/application/repositories/test_results_repository_provider.dart';
import 'package:indi_tool/core/application/result_buffer_provider.dart';
import 'package:indi_tool/core/domain/models/test_case.dart';
import 'package:indi_tool/core/services/load_runner.dart';

class IsLoadRunnerRunning extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void set(bool isRunning) {
    state = isRunning;
  }
}

final isLoadRunnerRunningStateProvider =
    NotifierProvider<IsLoadRunnerRunning, bool>(IsLoadRunnerRunning.new);

class LoadRunHandle {
  LoadRunHandle(this.signal, this.cancelToken);

  final CancellationSignal signal;
  final CancelToken cancelToken;

  void cancel() {
    if (!signal.isCancelled) {
      signal.cancel();
      if (!cancelToken.isCancelled) {
        cancelToken.cancel('User requested cancellation');
      }
    }
  }
}

class LoadRunnerController {
  LoadRunnerController({required this.buffer, required this.repo});

  final ResultBuffer buffer;
  final TestResultsRepository repo;
  final LoadRunner _runner = LoadRunner();

  LoadRunHandle? _current;

  Future<void> runLoadTest(TestCase testCase) async {
    if (_current != null) return;

    final handle = LoadRunHandle(CancellationSignal(), CancelToken());
    _current = handle;
    try {
      final stream = _runner.runStream(
        testCase,
        signal: handle.signal,
        cancelToken: handle.cancelToken,
      );
      await for (final result in stream) {
        buffer.add(result);
      }
      final snapshot = buffer.finalize();
      if (snapshot.isNotEmpty) {
        await repo.save(testCaseId: testCase.id, results: snapshot);
      }
    } finally {
      _current = null;
    }
  }

  void stop() {
    _current?.cancel();
  }
}

final loadRunnerControllerProvider = Provider<LoadRunnerController>((ref) {
  return LoadRunnerController(
    buffer: ref.read(resultBufferProvider),
    repo: ref.read(testResultsRepositoryProvider),
  );
});

Future<void> runLoadTest(WidgetRef ref, TestCase testCase) async {
  final running = ref.read(isLoadRunnerRunningStateProvider);
  if (running) return;
  ref.read(isLoadRunnerRunningStateProvider.notifier).set(true);
  try {
    await ref.read(loadRunnerControllerProvider).runLoadTest(testCase);
  } finally {
    ref.read(isLoadRunnerRunningStateProvider.notifier).set(false);
  }
}

void stopLoadTest(WidgetRef ref) {
  ref.read(loadRunnerControllerProvider).stop();
}
