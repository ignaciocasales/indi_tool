import 'dart:async';
import 'dart:collection';

import 'package:indi_tool/core/isolate_pool_state.dart';
import 'package:indi_tool/core/pooled_job.dart';
import 'package:indi_tool/core/single_task_worker.dart';

class IsolatePool {
  final int _size;
  final List<SingleTaskWorker> _workers = [];
  final Queue<(Task, Completer)> _queue = Queue();

  IsolatePoolState _state = IsolatePoolState.notStarted;

  IsolatePool(this._size);

  Future<T> schedule<T>(final Task task) {
    if (_state == IsolatePoolState.stopped) {
      throw StateError('Isolate pool is stopped');
    }

    final Completer<T> completer = Completer<T>.sync();

    _queue.add((task, completer));

    _runNext();

    return completer.future.then((value) {
      _runNext();

      return value;
    });
  }

  void _runNext() {
    final SingleTaskWorker? worker =
        _workers.where((w) => !w.isBusy).firstOrNull;
    if (worker != null && _queue.isNotEmpty) {
      final (task, completer) = _queue.removeFirst();

      worker.sendRequest(task, completer);
    }
  }

  Future<void> start() async {
    for (var i = 0; i < _size; i++) {
      final worker = await SingleTaskWorker.spawn();

      _workers.add(worker);
    }

    _state = IsolatePoolState.started;
  }

  void stop() {
    for (final SingleTaskWorker w in _workers) {
      w.close();
    }

    _state = IsolatePoolState.stopped;
  }
}
