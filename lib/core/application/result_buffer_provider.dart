import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/core/domain/models/test_result.dart';

class ResultBuffer {
  final _controller = StreamController<List<TestCaseResult>>.broadcast();
  final _buffer = <TestCaseResult>[];

  ResultBuffer() {
    _controller.onListen = () {
      _controller.add(List.unmodifiable(_buffer));
    };
  }

  Stream<List<TestCaseResult>> get stream => _controller.stream;

  void add(TestCaseResult result) {
    _buffer.add(result);
    if (!_controller.isClosed) {
      _controller.add(List.unmodifiable(_buffer));
    }
  }

  void clear() {
    _buffer.clear();
    if (!_controller.isClosed) {
      _controller.add(const []);
    }
  }

  /// Called when test completes. Snapshot is returned and memory is freed,
  /// but stream stays open for reuse in future runs.
  List<TestCaseResult> finalize() {
    final snapshot = List<TestCaseResult>.from(_buffer);
    clear(); // free memory
    return snapshot;
  }

  void dispose() {
    if (!_controller.isClosed) {
      _controller.close();
    }
  }
}

final resultBufferProvider = Provider<ResultBuffer>((ref) {
  final buffer = ResultBuffer();
  ref.onDispose(() {
    buffer.dispose();
  });
  return buffer;
});

final liveResultsProvider = StreamProvider<List<TestCaseResult>>((ref) {
  final buffer = ref.watch(resultBufferProvider);
  return buffer.stream;
});
