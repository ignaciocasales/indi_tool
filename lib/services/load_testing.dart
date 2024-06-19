import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:indi_tool/core/isolate_pool.dart';
import 'package:indi_tool/schema/request.dart';
import 'package:indi_tool/schema/response.dart';
import 'package:indi_tool/schema/test_scenario.dart';

import 'package:indi_tool/services/http/http_service.dart';
import 'package:indi_tool/services/http_task.dart';

class LoadTestingService {
  final GenericHttpService _httpService;

  LoadTestingService(this._httpService);

  Future<List<IndiHttpResponse>> loadTest(TestScenario testScenario) async {
    final results = <IndiHttpResponse>[];

    // TODO: Remove overrides.
    final int n = testScenario.numberOfRequests + 10;
    final int t = testScenario.threadPoolSize + 1;

    final IndiHttpRequest request = testScenario.request;

    final IsolatePool pool = IsolatePool(t);

    await pool.start();

    final futures = <Future<IndiHttpResponse>>[];
    for (int i = 0; i < n; i++) {
      final task = HttpTask(request, _httpService);

      futures.add(pool.schedule(task));
    }

    // Collect the results
    // TODO: Figure out streaming values.
    final responses = await Future.wait(futures);
    results.addAll(responses);

    pool.stop();

    for (var response in responses) {
      if (kDebugMode) {
        print('Response: ${response.status}');
      }
    }

    return results;
  }
}
