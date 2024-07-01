import 'package:indi_tool/models/common/http_method.dart';
import 'package:indi_tool/models/workspace/indi_http_header.dart';
import 'package:indi_tool/models/workspace/indi_http_param.dart';

class IndiHttpRequest {
  IndiHttpRequest({
    this.id,
    HttpMethod? method,
    String? url,
    String? body,
    List<IndiHttpParam>? parameters,
    List<IndiHttpHeader>? headers,
  })  : method = method ?? HttpMethod.get,
        url = url ?? '',
        body = body ?? '',
        parameters = parameters ?? List<IndiHttpParam>.empty(growable: true),
        headers = headers ?? List<IndiHttpHeader>.empty(growable: true);

  final int? id;
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
      method: method ?? this.method,
      url: url ?? this.url,
      body: body ?? this.body,
      parameters: parameters ?? this.parameters,
      headers: headers ?? this.headers,
    );
  }
}
