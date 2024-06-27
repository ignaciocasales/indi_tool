import 'package:indi_tool/models/common/http_method.dart';
import 'package:indi_tool/models/workspace/indi_http_header.dart';
import 'package:indi_tool/models/workspace/indi_http_param.dart';
import 'package:uuid/uuid.dart';

class IndiHttpRequest {
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
