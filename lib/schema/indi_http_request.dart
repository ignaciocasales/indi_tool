import 'package:indi_tool/models/common/http_method.dart';
import 'package:indi_tool/schema/indi_http_header.dart';
import 'package:indi_tool/schema/indi_http_param.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'indi_http_request.g.dart';

@JsonSerializable(
  includeIfNull: false,
  fieldRename: FieldRename.snake,
)
class IndiHttpRequest {
  static const String tableName = 'indi_http_requests';

  IndiHttpRequest({
    String? id,
    String? name,
    HttpMethod? method,
    String? url,
    String? body,
    List<IndiHttpParam>? parameters,
    List<IndiHttpHeader>? headers,
  })  : id = id ?? const Uuid().v4(),
        name = name ?? '',
        method = method ?? HttpMethod.get,
        url = url ?? '',
        body = body ?? '',
        parameters = parameters ?? List<IndiHttpParam>.empty(growable: true),
        headers = headers ?? List<IndiHttpHeader>.empty(growable: true);

  final String id;
  final String name;
  final HttpMethod method;
  final String url;
  final String body;
  final List<IndiHttpParam> parameters;
  final List<IndiHttpHeader> headers;

  factory IndiHttpRequest.fromJson(Map<String, dynamic> json) =>
      _$IndiHttpRequestFromJson(json);

  Map<String, dynamic> toInsert(final String testScenarioId) {
    final map = _$IndiHttpRequestToJson(this);
    map.removeWhere((key, value) => key == 'parameters' || key == 'headers');
    map['test_scenario_id'] = testScenarioId;
    return map;
  }

  IndiHttpRequest copyWith({
    String? name,
    HttpMethod? method,
    String? url,
    String? body,
    List<IndiHttpParam>? parameters,
    List<IndiHttpHeader>? headers,
  }) {
    return IndiHttpRequest(
      id: id,
      name: name ?? this.name,
      method: method ?? this.method,
      url: url ?? this.url,
      body: body ?? this.body,
      parameters: parameters ?? this.parameters,
      headers: headers ?? this.headers,
    );
  }
}
