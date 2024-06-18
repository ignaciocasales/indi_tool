import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:indi_tool/schema/request.dart';
import 'package:indi_tool/schema/test_scenario.dart';

import 'package:indi_tool/services/http/http_service.dart';

class LoadTestingService {
  final GenericHttpService _httpService;

  LoadTestingService(this._httpService);

  Future<List<IndiHttpResponse>> loadTest(TestScenario testScenario) async {
    final results = <IndiHttpResponse>[];

    final int n = testScenario.numberOfRequests + 10;
    final int t = testScenario.threadPoolSize + 1;

    final IndiHttpRequest request = testScenario.request;

    final List<Worker> workers = <Worker>[];
    for (int i = 0; i < t; i++) {
      final Worker worker = await Worker.spawn();
      workers.add(worker);
    }

    final responseFutures = <Future<IndiHttpResponse>>[];
    for (int i = 0; i < n; i++) {
      final worker = workers[i % t];
      responseFutures.add(worker.sendRequest(_httpService, request));
    }

    // Collect the results
    final responses = await Future.wait(responseFutures);
    results.addAll(responses);

    for (final w in workers) {
      w.close();
    }

    for (var response in responses) {
      print('Response: ${response.status}');
    }

    return results;
  }
}

class Worker {
  final SendPort _commands;
  final ReceivePort _responses;
  final Map<int, Completer<Object?>> _activeRequests = {};
  int _idCounter = 0;
  bool _closed = false;

  Future<IndiHttpResponse> sendRequest(
      GenericHttpService http, IndiHttpRequest request) async {
    if (_closed) throw StateError('Closed');

    final completer = Completer<IndiHttpResponse>.sync();

    final id = _idCounter++;

    _activeRequests[id] = completer;
    _commands.send((id, [http, request]));

    return await completer.future;
  }

  static Future<Worker> spawn() async {
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

    return Worker._(receivePort, sendPort);
  }

  Worker._(this._responses, this._commands) {
    _responses.listen(_handleResponsesFromIsolate);
  }

  void _handleResponsesFromIsolate(dynamic message) {
    final (int id, Object? response) = message as (int, Object?);
    final completer = _activeRequests.remove(id)!;

    if (response is RemoteError) {
      completer.completeError(response);
    } else {
      completer.complete(response);
    }

    if (_closed && _activeRequests.isEmpty) _responses.close();
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
      final (int id, List<dynamic> params) = message as (int, List<dynamic>);
      try {
        final GenericHttpService http = params[0] as GenericHttpService;
        final IndiHttpRequest request = params[1] as IndiHttpRequest;
        final HttpClientResponse response = await http.sendRequest(request);
        final status = response.statusCode;
        IndiHttpResponse indiResponse = IndiHttpResponse(status.toString());
        sendPort.send((id, indiResponse));
      } catch (e) {
        sendPort.send((id, RemoteError(e.toString(), '')));
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
      if (_activeRequests.isEmpty) _responses.close();
      print('--- port closed --- ');
    }
  }
}

class IndiHttpResponse {
  final String status;

  IndiHttpResponse(this.status);
}
