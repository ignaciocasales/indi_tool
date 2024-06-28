import 'dart:async';
import 'dart:isolate';

import 'package:indi_tool/core/async/task.dart';

class SingleTaskWorker {
  SingleTaskWorker._(
    this._responses,
    this._commands,
  ) {
    _responses.listen(_handleResponsesFromIsolate);
  }

  final ReceivePort _responses;
  final SendPort _commands;

  bool _closed = false;

  bool _busy = false;
  Completer? _currentCompleter;

  bool get isBusy => _busy;

  Future<T> sendRequest<T>(Task<T> task, Completer<T> upstream) {
    if (_closed) throw StateError('Closed');
    if (_busy) throw StateError('Busy');

    _busy = true;

    _currentCompleter = upstream;

    _commands.send(task);

    return upstream.future;
  }

  static Future<SingleTaskWorker> spawn() async {
    // Create a receive port and add its initial message handler
    final initPort = RawReceivePort();
    final connection = Completer<(ReceivePort, SendPort)>.sync();
    initPort.handler = (initialMessage) {
      final commandPort = initialMessage as SendPort;
      connection.complete((
        ReceivePort.fromRawReceivePort(initPort),
        commandPort,
      ));
    };

    // Spawn the isolate.
    try {
      await Isolate.spawn(_startRemoteIsolate, (initPort.sendPort));
    } on Object {
      initPort.close();
      rethrow;
    }

    final (ReceivePort receivePort, SendPort sendPort) =
        await connection.future;

    return SingleTaskWorker._(receivePort, sendPort);
  }

  void _handleResponsesFromIsolate(dynamic message) {
    if (message is RemoteError) {
      _currentCompleter!.completeError(message);
    } else {
      _currentCompleter!.complete(message);
    }

    _busy = false;

    _currentCompleter = null;

    if (_closed) _responses.close();
  }

  static void _handleCommandsToIsolate(
    ReceivePort receivePort,
    SendPort sendPort,
  ) {
    receivePort.listen((message) async {
      if (message == 'shutdown') {
        receivePort.close();
        return;
      }

      final task = message as Task;
      try {
        final result = await task.execute();
        sendPort.send(result);
      } catch (e) {
        sendPort.send(RemoteError(e.toString(), ''));
      }
    });
  }

  static void _startRemoteIsolate(SendPort sendPort) {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    _handleCommandsToIsolate(receivePort, sendPort);
  }

  void close() {
    if (!_closed) {
      _closed = true;
      _commands.send('shutdown');
      _responses.close();
    }
  }
}
