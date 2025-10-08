import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/core/application/result_buffer_provider.dart';
import 'package:indi_tool/core/domain/models/test_case.dart';
import 'package:indi_tool/core/services/load_runner.dart';

class LoadRunnerController {
  LoadRunnerController({required this.buffer});

  final ResultBuffer buffer;
  final LoadRunner _runner = LoadRunner();

  bool _isRunning = false;

  bool get isRunning => _isRunning;

  Future<void> runTest(TestCase testCase) async {
    if (_isRunning) return;
    _isRunning = true;

    final stream = _runner.runStream(testCase);
    await for (final result in stream) {
      buffer.add(result);
    }

    _isRunning = false;
  }
}

final loadRunnerControllerProvider = Provider<LoadRunnerController>(
  isAutoDispose: false,
  (ref) {
    final buffer = ref.read(resultBufferProvider);
    return LoadRunnerController(buffer: buffer);
  },
);
