import 'package:indi_tool/services/http/http_method.dart';

class IndiHttpRequest {
  // TODO: In the future all of this properties will be final.
  String id;
  String name;
  HttpMethod method;
  String url;
  String? body;
  List<IndiHttpParameter>? parameters;
  List<IndiHttpHeader>? headers;

  IndiHttpRequest({
    required this.id,
    required this.name,
    required this.method,
    required this.url,
    this.body,
    this.parameters,
    this.headers,
  });
}

class IndiHttpParameter {
  // TODO: In the future all of this properties will be final.
  String key;
  String value;
  bool enabled;
  String description;

  IndiHttpParameter({
    required this.key,
    required this.value,
    required this.enabled,
    required this.description,
  });

  IndiHttpParameter copyWith({
    String? key,
    String? value,
    bool? enabled,
    String? description,
  }) {
    return IndiHttpParameter(
      key: key ?? this.key,
      value: value ?? this.value,
      enabled: enabled ?? this.enabled,
      description: description ?? this.description,
    );
  }

  static IndiHttpParameter newEmpty() {
    return IndiHttpParameter(
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

class IndiHttpHeader {
  // TODO: In the future all of this properties will be final.
  String key;
  String value;
  bool enabled;
  String description;

  IndiHttpHeader({
    required this.key,
    required this.value,
    required this.enabled,
    required this.description,
  });
}
