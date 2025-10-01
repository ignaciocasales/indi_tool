import 'dart:async';

import 'package:dio/dio.dart';
import 'package:indi_tool/models/test_case.dart';
import 'package:indi_tool/models/test_result.dart';

class LoadRunner {
  LoadRunner({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  Stream<TestCaseResult> runStream(TestCase testCase) async* {
    final dio = _dio;

    // Prepare common request parts
    final headers = {
      for (final h in testCase.httpHeaders.where((h) => h.enabled)) h.key: h.value,
    };
    final queryParams = {
      for (final p in testCase.httpParams.where((p) => p.enabled)) p.key: p.value,
    };

    dio.options = BaseOptions(
      connectTimeout: Duration(milliseconds: testCase.httpTimeoutInMillis),
      receiveTimeout: Duration(milliseconds: testCase.httpTimeoutInMillis),
      sendTimeout: Duration(milliseconds: testCase.httpTimeoutInMillis),
      headers: headers,
      responseType: ResponseType.plain,
      validateStatus: (_) => true,
    );

    final total = testCase.numberOfRequests;
    var concurrency = testCase.numberOfConcurrentUsers.clamp(1, total);

    // Edge case: nothing to do
    if (total <= 0) {
      return; // yields an empty stream
    }

    // Ensure we never spawn more workers than tasks
    if (concurrency > total) concurrency = total;

    final uriBase = Uri.parse(testCase.httpUrl);

    // Output stream of results
    final out = StreamController<TestCaseResult>();

    // Shared counter as a lightweight work queue
    int nextIndex = 0;
    int active = concurrency;

    Future<void> worker() async {
      while (true) {
        // Synchronously grab the next index
        final i = nextIndex;
        if (i >= total) break;
        nextIndex = i + 1;

        final start = DateTime.now();
        try {
          final uri = uriBase.replace(
            queryParameters: queryParams.isEmpty ? null : queryParams,
          );
          final resp = await dio.request<String>(
            uri.toString(),
            data: testCase.httpBody.isEmpty ? null : testCase.httpBody,
            options: Options(method: testCase.httpMethod),
          );
          final end = DateTime.now();
          out.add(
            TestCaseResult(
              requestMethod: testCase.httpMethod,
              requestUrl: uri.toString(),
              responseStatusCode: resp.statusCode ?? 0,
              responseDurationInMillis: end.difference(start).inMilliseconds,
              responseBody: resp.data ?? '',
              responseStartDateTime: start.toIso8601String(),
              responseEndDateTime: end.toIso8601String(),
              responseHeaders: _stringifyHeaders(resp.headers.map),
            ),
          );
        } catch (e) {
          final end = DateTime.now();
          out.add(
            TestCaseResult(
              requestMethod: testCase.httpMethod,
              requestUrl: testCase.httpUrl,
              responseStatusCode: 0,
              responseDurationInMillis: end.difference(start).inMilliseconds,
              responseBody: _safeErr(e),
              responseStartDateTime: start.toIso8601String(),
              responseEndDateTime: end.toIso8601String(),
              responseHeaders: {},
            ),
          );
        }
      }

      // When a worker finishes its loop, decrement active and close if last
      if (--active == 0 && !out.isClosed) {
        await out.close();
      }
    }

    // Start workers
    for (int i = 0; i < concurrency; i++) {
      // fire-and-forget; we’ll await completion by yielding the stream below
      unawaited(worker());
    }

    // Expose the merged results
    yield* out.stream;
  }

  Map<String, String> _stringifyHeaders(Map<String, List<String>> headers) {
    final out = <String, String>{};
    headers.forEach((k, v) => out[k] = v.join(','));
    return out;
  }

  String _safeErr(Object e) {
    try {
      return e.toString();
    } catch (_) {
      return 'Unknown error';
    }
  }
}
