import 'package:indi_tool/models/common/http_method.dart';
import 'package:indi_tool/schema/indi_http_header.dart';
import 'package:indi_tool/schema/indi_http_param.dart';
import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

part 'indi_http_request.g.dart';

@embedded
class IndiHttpRequest {
  IndiHttpRequest({
    required this.id,
    this.name = '',
    this.method = HttpMethod.get,
    this.url = '',
    this.body = '',
    required this.parameters,
    required this.headers,
  });

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

  static IndiHttpRequest newWith({
    String? name,
    HttpMethod? method,
    String? url,
    String? body,
    List<IndiHttpParam>? parameters,
    List<IndiHttpHeader>? headers,
  }) {
    return IndiHttpRequest(
      id: const Uuid().v4(),
      name: name ?? '',
      method: method ?? HttpMethod.get,
      url: url ?? '',
      body: body ?? '',
      parameters: parameters ?? List.empty(growable: true),
      headers: headers ?? List.empty(growable: true),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IndiHttpRequest &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          method == other.method &&
          url == other.url &&
          body == other.body &&
          parameters == other.parameters &&
          headers == other.headers;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      method.hashCode ^
      url.hashCode ^
      body.hashCode ^
      parameters.hashCode ^
      headers.hashCode;
}
