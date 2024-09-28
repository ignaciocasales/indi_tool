import 'package:indi_tool/models/common/body_type.dart';
import 'package:indi_tool/models/common/http_method.dart';
import 'package:indi_tool/models/workspace/indi_http_header.dart';
import 'package:indi_tool/models/workspace/indi_http_param.dart';
import 'package:uuid/uuid.dart';

class IndiHttpRequest {
  IndiHttpRequest({
    String? id,
    HttpMethod? method,
    String? url,
    BodyType? bodyType,
    List<int>? body,
    int? timeoutMillis,
    List<IndiHttpParam>? parameters,
    List<IndiHttpHeader>? headers,
  })  : id = id ?? const Uuid().v4(),
        method = method ?? HttpMethod.get,
        url = url ?? '',
        bodyType = bodyType ?? BodyType.none,
        body = body ?? List<int>.empty(growable: false),
        timeoutMillis = timeoutMillis ?? 5000,
        parameters = parameters ?? List<IndiHttpParam>.empty(growable: false),
        headers = headers ?? List<IndiHttpHeader>.empty(growable: false);

  final String id;
  final HttpMethod method;
  final String url;
  final BodyType bodyType;
  final List<int> body;
  final int timeoutMillis;
  final List<IndiHttpParam> parameters;
  final List<IndiHttpHeader> headers;

  IndiHttpRequest copyWith({
    String? name,
    HttpMethod? method,
    String? url,
    BodyType? bodyType,
    List<int>? body,
    int? timeoutMillis,
    List<IndiHttpParam>? parameters,
    List<IndiHttpHeader>? headers,
  }) {
    return IndiHttpRequest(
      id: id,
      method: method ?? this.method,
      url: url ?? this.url,
      bodyType: bodyType ?? this.bodyType,
      body: body ?? this.body,
      timeoutMillis: timeoutMillis ?? this.timeoutMillis,
      parameters: parameters ?? this.parameters,
      headers: headers ?? this.headers,
    );
  }
}
