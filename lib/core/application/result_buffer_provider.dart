import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/core/domain/models/test_result.dart';

class ResultBuffer {
  final _controller = StreamController<List<TestCaseResult>>.broadcast();
  final _buffer = <TestCaseResult>[];
  final int flushThreshold;

  ResultBuffer({this.flushThreshold = 500});

  Stream<List<TestCaseResult>> get stream => _controller.stream;

  List<TestCaseResult> get current => List.unmodifiable(_buffer);

  void add(TestCaseResult result) {
    _buffer.add(result);

    // Optionally notify UI or aggregators
    if (_buffer.length % 50 == 0) {
      _controller.add(List.unmodifiable(_buffer));
    }

    // Optional: auto-flush if too large
    if (_buffer.length >= flushThreshold) {
      flushPartial();
    }
  }

  /// Clear or flush some items when buffer gets too big
  void flushPartial() {
    // For example, keep last 100 items
    if (_buffer.length > 100) {
      _buffer.removeRange(0, _buffer.length - 100);
    }
  }

  /// Called when test completes
  List<TestCaseResult> finalize() {
    final snapshot = List<TestCaseResult>.from(_buffer);
    _controller.add(snapshot);
    _controller.close();
    return snapshot;
  }

  void dispose() {
    _controller.close();
  }
}

final resultBufferProvider = Provider<ResultBuffer>(isAutoDispose: true, (ref) {
  final buffer = ResultBuffer();
  ref.onDispose(() {
    buffer.dispose();
  });
  return buffer;
});

final liveResultsProvider = StreamProvider<List<TestCaseResult>>(
  isAutoDispose: true,
  (ref) {
    final buffer = ref.watch(resultBufferProvider);
    return buffer.stream;
  },
);
