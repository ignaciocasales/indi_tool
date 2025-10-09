import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/core/domain/models/test_result.dart';

class ResultBuffer {
  final _controller = StreamController<List<TestCaseResult>>.broadcast();
  final _buffer = <TestCaseResult>[];
  final int flushThreshold;

  ResultBuffer({this.flushThreshold = 500}) {
    _controller.onListen = () {
      _controller.add(List.unmodifiable(_buffer));
    };
  }

  Stream<List<TestCaseResult>> get stream => _controller.stream;

  void add(TestCaseResult result) {
    _buffer.add(result);

    _controller.add(List.unmodifiable(_buffer));
  }

  void clear() {
    _buffer.clear();
    _controller.add(List.unmodifiable(_buffer));
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

final liveResultsProvider = StreamProvider<List<TestCaseResult>>((ref) {
  final buffer = ref.watch(resultBufferProvider);
  return buffer.stream;
});
