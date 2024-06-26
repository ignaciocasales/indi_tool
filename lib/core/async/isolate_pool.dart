import 'dart:async';
import 'dart:collection';

import 'package:indi_tool/core/async/isolate_pool_state.dart';
import 'package:indi_tool/core/async/single_task_worker.dart';
import 'package:indi_tool/core/async/task.dart';

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

    // Attempt to run next.
    // If the queue is started and there is a worker available.
    _runNext();

    return completer.future.then((value) {
      // Attempt to run next.
      // If there is another task in the queue and there is a worker available.
      _runNext();

      return value;
    });
  }

  void _runNext() {
    final List<SingleTaskWorker> workers =
        _workers.where((w) => !w.isBusy).toList();

    for (final SingleTaskWorker w in workers) {
      if (_queue.isNotEmpty) {
        final (task, completer) = _queue.removeFirst();

        w.sendRequest(task, completer);
      }
    }
  }

  Future<void> start() async {
    for (var i = 0; i < _size; i++) {
      final worker = await SingleTaskWorker.spawn();

      _workers.add(worker);
    }

    _state = IsolatePoolState.started;

    // Attempt to run next.
    // If the queue had items prior to starting the pool.
    _runNext();
  }

  void stop() {
    for (final SingleTaskWorker w in _workers) {
      w.close();
    }

    _state = IsolatePoolState.stopped;
  }
}
