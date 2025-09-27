import 'package:uuid/uuid.dart';

class TestCaseResults {
  TestCaseResults({
    String? testCaseId,
    List<TestCaseResult>? results,
  }) : testCaseId = testCaseId ?? const Uuid().v4(),
        results = results ?? [];

  final String testCaseId;
  final List<TestCaseResult> results;
}

class TestCaseResult {
  TestCaseResult({
    String? id,
    String? requestMethod,
    String? requestUrl,
    int? responseStatusCode,
    int? responseDurationInMillis,
    String? responseBody,
    String? responseStartDateTime,
    String? responseEndDateTime,
    Map<String, String>? responseHeaders,
  }) : id = id ?? const Uuid().v4(),
        requestMethod = requestMethod ?? '',
        requestUrl = requestUrl ?? '',
        responseStatusCode = responseStatusCode ?? 0,
        responseDurationInMillis = responseDurationInMillis ?? 0,
        responseBody = responseBody ?? '',
        responseStartDateTime = responseStartDateTime ?? '',
        responseEndDateTime = responseEndDateTime ?? '',
        responseHeaders = responseHeaders ?? {};

  final String id;
  final String requestMethod;
  final String requestUrl;
  final int responseStatusCode;
  final int responseDurationInMillis;
  final String responseBody;
  final String responseStartDateTime;
  final String responseEndDateTime;
  final Map<String, String> responseHeaders;
}