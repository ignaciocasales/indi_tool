import 'package:indi_tool/services/http/http_method.dart';

class HttpRequest {
  // TODO: In the future all of this properties will be final.
  String id;
  String name;
  HttpMethod method;
  String url;
  String? body;
  List<HttpRequestParameter>? parameters;
  List<HttpRequestHeader>? headers;

  HttpRequest({
    required this.id,
    required this.name,
    required this.method,
    required this.url,
    this.body,
    this.parameters,
    this.headers,
  });
}

class HttpRequestParameter {
  // TODO: In the future all of this properties will be final.
  String key;
  String value;
  bool enabled;
  String description;

  HttpRequestParameter({
    required this.key,
    required this.value,
    required this.enabled,
    required this.description,
  });

  HttpRequestParameter copyWith({
    String? key,
    String? value,
    bool? enabled,
    String? description,
  }) {
    return HttpRequestParameter(
      key: key ?? this.key,
      value: value ?? this.value,
      enabled: enabled ?? this.enabled,
      description: description ?? this.description,
    );
  }

  static HttpRequestParameter newEmpty() {
    return HttpRequestParameter(
      key: '',
      value: '',
      enabled: false,
      description: '',
    );
  }

  bool hasValue() {
    return key.isNotEmpty ||
        value.isNotEmpty ||
        description.isNotEmpty ||
        enabled;
  }
}

class HttpRequestHeader {
  // TODO: In the future all of this properties will be final.
  String key;
  String value;
  bool enabled;
  String description;

  HttpRequestHeader({
    required this.key,
    required this.value,
    required this.enabled,
    required this.description,
  });
}
