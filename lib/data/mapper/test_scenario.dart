import 'dart:convert';

import 'package:es_compression/zstd.dart';
import 'package:indi_tool/data/source/database.dart';
import 'package:indi_tool/models/common/body_type.dart';
import 'package:indi_tool/models/common/http_method.dart';
import 'package:indi_tool/models/workspace/indi_http_header.dart';
import 'package:indi_tool/models/workspace/indi_http_param.dart';
import 'package:indi_tool/models/workspace/indi_http_request.dart';
import 'package:indi_tool/models/workspace/test_scenario.dart';

class TestScenarioMapper {
  const TestScenarioMapper._();

  static TestScenario fromEntry(final TestScenarioTableData entry) {
    return TestScenario(
      id: entry.id,
      name: entry.name,
      description: entry.description,
      numberOfRequests: entry.numberOfRequests,
      threadPoolSize: entry.threadPoolSize,
      request: IndiHttpRequest(
        method: HttpMethod.fromString(entry.method),
        url: entry.url,
        bodyType: BodyType.fromString(entry.bodyType),
        body: zstd.decode(entry.body.toList()),
        timeoutMillis: entry.timeoutMillis,
        parameters:
            (json.decode(utf8.decode(zstd.decode(entry.httpParams.toList())))
                    as List<dynamic>)
                .map((e) => json.decode(e) as Map<String, dynamic>)
                .map((param) => IndiHttpParam.fromJson(param))
                .toList(),
        headers:
            (json.decode(utf8.decode(zstd.decode(entry.httpHeaders.toList())))
                    as List<dynamic>)
                .map((e) => json.decode(e) as Map<String, dynamic>)
                .map((header) => IndiHttpHeader.fromJson(header))
                .toList(),
      ),
    );
  }

  static List<TestScenario> fromEntries(final List<TestScenarioTableData> entries) {
    return entries.map(fromEntry).toList();
  }
}
