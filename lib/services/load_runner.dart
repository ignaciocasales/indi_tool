import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:indi_tool/models/test_case.dart';
import 'package:indi_tool/models/test_result.dart';

class LoadRunner {
  LoadRunner({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  Future<TestCaseResults> run(TestCase testCase) async {
    final results = TestCaseResults(testCaseId: testCase.id);

    // Prepare common request parts
    final Map<String, String> headers = {
      for (final h in testCase.httpHeaders.where((h) => h.enabled)) h.key: h.value,
    };

    // Build query params
    final Map<String, dynamic> queryParams = {
      for (final p in testCase.httpParams.where((p) => p.enabled)) p.key: p.value,
    };

    // Configure Dio
    _dio.options = BaseOptions(
      connectTimeout: Duration(milliseconds: testCase.httpTimeoutInMillis),
      receiveTimeout: Duration(milliseconds: testCase.httpTimeoutInMillis),
      sendTimeout: Duration(milliseconds: testCase.httpTimeoutInMillis),
      headers: headers,
      responseType: ResponseType.plain, // we capture body as string
      validateStatus: (_) => true, // collect all
    );

    final int total = testCase.numberOfRequests;
    final int concurrency = testCase.numberOfConcurrentUsers.clamp(1, total);

    // Create a simple worker pool with bounded concurrency
    final controller = StreamController<int>();
    // schedule indices 0..total-1
    for (int i = 0; i < total; i++) {
      controller.add(i);
    }
    // close when done scheduling
    unawaited(Future(() async {
      await Future<void>.delayed(Duration.zero);
      await controller.close();
    }()));

    final List<Future<void>> workers = List.generate(concurrency, (_) async {
      await for (final _ in controller.stream) {
        final now = DateTime.now();
        try {
          final uri = Uri.parse(testCase.httpUrl).replace(
            queryParameters: queryParams.isEmpty ? null : queryParams,
          );

          final Response<String> response = await _dio.request<String>(
            uri.toString(),
            data: testCase.httpBody.isEmpty ? null : testCase.httpBody,
            options: Options(method: testCase.httpMethod),
          );

          final end = DateTime.now();
          final duration = end.difference(now).inMilliseconds;
          results.results.add(
            TestCaseResult(
              requestMethod: testCase.httpMethod,
              requestUrl: uri.toString(),
              responseStatusCode: response.statusCode ?? 0,
              responseDurationInMillis: duration,
              responseBody: response.data ?? '',
              responseStartDateTime: now.toIso8601String(),
              responseEndDateTime: end.toIso8601String(),
              responseHeaders: _stringifyHeaders(response.headers.map),
            ),
          );
        } catch (e) {
          final end = DateTime.now();
          final duration = end.difference(now).inMilliseconds;
          results.results.add(
            TestCaseResult(
              requestMethod: testCase.httpMethod,
              requestUrl: testCase.httpUrl,
              responseStatusCode: 0,
              responseDurationInMillis: duration,
              responseBody: _safeErr(e),
              responseStartDateTime: now.toIso8601String(),
              responseEndDateTime: end.toIso8601String(),
              responseHeaders: {},
            ),
          );
        }
      }
    });

    await Future.wait(workers);
    return results;
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
