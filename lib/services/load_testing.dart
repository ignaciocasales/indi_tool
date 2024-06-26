import 'dart:async';

import 'package:indi_tool/core/async/isolate_pool.dart';
import 'package:indi_tool/schema/indi_http_request.dart';
import 'package:indi_tool/schema/indi_http_response.dart';
import 'package:indi_tool/schema/test_scenario.dart';
import 'package:indi_tool/services/http/http_service.dart';
import 'package:indi_tool/services/http/http_task.dart';

class LoadTestingService {
  final GenericHttpService _httpService;

  LoadTestingService(this._httpService);

  late IsolatePool? _pool;

  Stream<IndiHttpResponse> loadTest(final TestScenario scenario) async* {
    // TODO: Remove overrides.
    final int n = scenario.numberOfRequests + 10;
    final int t = scenario.threadPoolSize + 1;

    final IndiHttpRequest request = scenario.request;

    _pool = IsolatePool(t);

    try {
      final futures = List<Future<IndiHttpResponse>>.empty(growable: true);
      for (int i = 0; i < n; i++) {
        final task = HttpTask(request, _httpService);

        futures.add(_pool!.schedule(task));
      }

      await _pool!.start();

      for (final future in futures) {
        yield await future;
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    } finally {
      _pool!.stop();
      _pool = null;
    }
  }

  void cancelLoadTest() {
    _pool?.stop();
    _pool = null;
  }
}
