import 'dart:convert';

import 'package:uuid/uuid.dart';

class TestCaseResults {
  TestCaseResults({String? testCaseId, List<TestCaseResult>? results})
    : testCaseId = testCaseId ?? const Uuid().v4(),
      results = results ?? [];

  final String testCaseId;
  final List<TestCaseResult> results;

  TestCaseResults copyWith({
    String? testCaseId,
    List<TestCaseResult>? results,
  }) {
    return TestCaseResults(
      testCaseId: testCaseId ?? this.testCaseId,
      results: results ?? this.results,
    );
  }

  static TestCaseResults fromJson(Map<String, dynamic> json) {
    return TestCaseResults(
      testCaseId: json['testCaseId'] as String?,
      results: (json['results'] as List<dynamic>?)
          ?.map(
            (e) => TestCaseResult(
              id: e['id'] as String?,
              requestMethod: e['requestMethod'] as String?,
              requestUrl: e['requestUrl'] as String?,
              responseStatusCode: e['responseStatusCode'] as int?,
              responseDurationInMillis: e['responseDurationInMillis'] as int?,
              responseBody: e['responseBody'] as String?,
              responseStartDateTime: e['responseStartDateTime'] as String?,
              responseEndDateTime: e['responseEndDateTime'] as String?,
              responseHeaders: (e['responseHeaders'] as Map<String, dynamic>?)
                  ?.map((key, value) => MapEntry(key, value as String)),
            ),
          )
          .toList(),
    );
  }

  static List<TestCaseResults> fromJsonArray(String jsonString) {
    final List<dynamic> jsonList = jsonString.isNotEmpty
        ? (jsonDecode(jsonString) as List<dynamic>)
        : [];
    return jsonList
        .map((e) => TestCaseResults.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Map<String, dynamic> toJson(TestCaseResults testCaseResults) {
    return {
      'testCaseId': testCaseResults.testCaseId,
      'results': testCaseResults.results
          .map(
            (e) => {
              'id': e.id,
              'requestMethod': e.requestMethod,
              'requestUrl': e.requestUrl,
              'responseStatusCode': e.responseStatusCode,
              'responseDurationInMillis': e.responseDurationInMillis,
              'responseBody': e.responseBody,
              'responseStartDateTime': e.responseStartDateTime,
              'responseEndDateTime': e.responseEndDateTime,
              'responseHeaders': e.responseHeaders,
            },
          )
          .toList(),
    };
  }
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

  bool get isSuccessStatusCode {
    return responseStatusCode >= 200 && responseStatusCode < 300;
  }

  TestCaseResult copyWith({
    String? id,
    String? requestMethod,
    String? requestUrl,
    int? responseStatusCode,
    int? responseDurationInMillis,
    String? responseBody,
    String? responseStartDateTime,
    String? responseEndDateTime,
    Map<String, String>? responseHeaders,
  }) {
    return TestCaseResult(
      id: id ?? this.id,
      requestMethod: requestMethod ?? this.requestMethod,
      requestUrl: requestUrl ?? this.requestUrl,
      responseStatusCode: responseStatusCode ?? this.responseStatusCode,
      responseDurationInMillis:
          responseDurationInMillis ?? this.responseDurationInMillis,
      responseBody: responseBody ?? this.responseBody,
      responseStartDateTime:
          responseStartDateTime ?? this.responseStartDateTime,
      responseEndDateTime: responseEndDateTime ?? this.responseEndDateTime,
      responseHeaders: responseHeaders ?? this.responseHeaders,
    );
  }

  static TestCaseResult fromJson(Map<String, dynamic> json) {
    return TestCaseResult(
      id: json['id'] as String?,
      requestMethod: json['requestMethod'] as String?,
      requestUrl: json['requestUrl'] as String?,
      responseStatusCode: json['responseStatusCode'] as int?,
      responseDurationInMillis: json['responseDurationInMillis'] as int?,
      responseBody: json['responseBody'] as String?,
      responseStartDateTime: json['responseStartDateTime'] as String?,
      responseEndDateTime: json['responseEndDateTime'] as String?,
      responseHeaders: (json['responseHeaders'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, value as String),
      ),
    );
  }

  static Map<String, dynamic> toJson(TestCaseResult result) {
    return {
      'id': result.id,
      'requestMethod': result.requestMethod,
      'requestUrl': result.requestUrl,
      'responseStatusCode': result.responseStatusCode,
      'responseDurationInMillis': result.responseDurationInMillis,
      'responseBody': result.responseBody,
      'responseStartDateTime': result.responseStartDateTime,
      'responseEndDateTime': result.responseEndDateTime,
      'responseHeaders': result.responseHeaders,
    };
  }
}
