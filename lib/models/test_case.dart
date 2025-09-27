import 'dart:convert';

import 'package:uuid/uuid.dart';

class TestCase {
  TestCase({
    String? id,
    String? name,
    String? description,
    String? httpMethod,
    String? httpUrl,
    String? httpBody,
    int? httpTimeoutInMillis,
    List<TestCaseHeader>? httpHeaders,
    List<TestCaseParam>? httpParams,
    int? numberOfRequests,
    int? numberOfConcurrentUsers,
  }) : id = id ?? const Uuid().v4(),
       name = name ?? 'New Test Case',
       description = description ?? '',
       httpMethod = httpMethod ?? 'GET',
       httpUrl = httpUrl ?? 'https://httpbin.org/get',
       httpBody = httpBody ?? '',
       httpTimeoutInMillis = httpTimeoutInMillis ?? 300,
       httpHeaders = httpHeaders ?? [],
       httpParams = httpParams ?? [],
       numberOfRequests = numberOfRequests ?? 1,
       numberOfConcurrentUsers = numberOfConcurrentUsers ?? 1;

  final String id;
  final String name;
  final String description;
  final String httpMethod;
  final String httpUrl;
  final String httpBody;
  final int httpTimeoutInMillis;
  final List<TestCaseHeader> httpHeaders;
  final List<TestCaseParam> httpParams;
  final int numberOfRequests;
  final int numberOfConcurrentUsers;

  TestCase copyWith({
    String? id,
    String? name,
    String? description,
    String? httpMethod,
    String? httpUrl,
    String? httpBody,
    int? httpTimeoutInMillis,
    List<TestCaseHeader>? httpHeaders,
    List<TestCaseParam>? httpParams,
    int? numberOfRequests,
    int? numberOfConcurrentUsers,
  }) {
    return TestCase(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      httpMethod: httpMethod ?? this.httpMethod,
      httpUrl: httpUrl ?? this.httpUrl,
      httpBody: httpBody ?? this.httpBody,
      httpTimeoutInMillis: httpTimeoutInMillis ?? this.httpTimeoutInMillis,
      httpHeaders: httpHeaders ?? this.httpHeaders,
      httpParams: httpParams ?? this.httpParams,
      numberOfRequests: numberOfRequests ?? this.numberOfRequests,
      numberOfConcurrentUsers:
          numberOfConcurrentUsers ?? this.numberOfConcurrentUsers,
    );
  }

  static TestCase fromJson(final Map<String, dynamic> map) {
    return TestCase(
      id: map['id'] as String?,
      name: map['name'] as String?,
      description: map['description'] as String?,
      httpMethod: map['httpMethod'] as String?,
      httpUrl: map['httpUrl'] as String?,
      httpBody: map['httpBody'] as String?,
      httpTimeoutInMillis: map['httpTimeoutInMillis'] as int?,
      httpHeaders: (map['httpHeaders'] as List<dynamic>?)
          ?.map((e) => TestCaseHeader.fromJson(e as Map<String, dynamic>))
          .toList(),
      httpParams: (map['httpParams'] as List<dynamic>?)
          ?.map((e) => TestCaseParam.fromJson(e as Map<String, dynamic>))
          .toList(),
      numberOfRequests: map['numberOfRequests'] as int?,
      numberOfConcurrentUsers: map['numberOfConcurrentUsers'] as int?,
    );
  }

  static List<TestCase> fromJsonArray(String jsonArray) {
    final List<dynamic> decoded = jsonDecode(jsonArray) as List;
    return decoded
        .map((e) => TestCase.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Map<String, dynamic> toJson(final TestCase testCase) {
    return {
      'id': testCase.id,
      'name': testCase.name,
      'description': testCase.description,
      'httpMethod': testCase.httpMethod,
      'httpUrl': testCase.httpUrl,
      'httpBody': testCase.httpBody,
      'httpTimeoutInMillis': testCase.httpTimeoutInMillis,
      'httpHeaders': testCase.httpHeaders
          .map((h) => TestCaseHeader.toJson(h))
          .toList(),
      'httpParams': testCase.httpParams
          .map((p) => TestCaseParam.toJson(p))
          .toList(),
      'numberOfRequests': testCase.numberOfRequests,
      'numberOfConcurrentUsers': testCase.numberOfConcurrentUsers,
    };
  }
}

class TestCaseHeader {
  TestCaseHeader({
    String? id,
    String? key,
    String? value,
    bool? enabled,
    String? description,
  }) : id = id ?? const Uuid().v4(),
       key = key ?? '',
       value = value ?? '',
       enabled = enabled ?? true,
       description = description ?? '';

  final String id;
  final String key;
  final String value;
  final bool enabled;
  final String description;

  TestCaseHeader copyWith({
    String? key,
    String? value,
    bool? enabled,
    String? description,
  }) {
    return TestCaseHeader(
      id: id,
      key: key ?? this.key,
      value: value ?? this.value,
      enabled: enabled ?? this.enabled,
      description: description ?? this.description,
    );
  }

  static TestCaseHeader fromJson(final Map<String, dynamic> map) {
    return TestCaseHeader(
      id: map['id'] as String?,
      key: map['key'] as String?,
      value: map['value'] as String?,
      enabled: map['enabled'] as bool?,
      description: map['description'] as String?,
    );
  }

  static Map<String, dynamic> toJson(final TestCaseHeader header) {
    return {
      'id': header.id,
      'key': header.key,
      'value': header.value,
      'enabled': header.enabled,
      'description': header.description,
    };
  }
}

class TestCaseParam {
  TestCaseParam({
    String? id,
    String? key,
    String? value,
    bool? enabled,
    String? description,
  }) : id = id ?? const Uuid().v4(),
       key = key ?? '',
       value = value ?? '',
       enabled = enabled ?? true,
       description = description ?? '';

  final String id;
  final String key;
  final String value;
  final bool enabled;
  final String description;

  TestCaseParam copyWith({
    String? key,
    String? value,
    bool? enabled,
    String? description,
  }) {
    return TestCaseParam(
      id: id,
      key: key ?? this.key,
      value: value ?? this.value,
      enabled: enabled ?? this.enabled,
      description: description ?? this.description,
    );
  }

  static TestCaseParam fromJson(final Map<String, dynamic> map) {
    return TestCaseParam(
      id: map['id'] as String?,
      key: map['key'] as String?,
      value: map['value'] as String?,
      enabled: map['enabled'] as bool?,
      description: map['description'] as String?,
    );
  }

  static Map<String, dynamic> toJson(final TestCaseParam param) {
    return {
      'id': param.id,
      'key': param.key,
      'value': param.value,
      'enabled': param.enabled,
      'description': param.description,
    };
  }
}
