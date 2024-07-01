import 'package:uuid/uuid.dart';

class IndiHttpParam {
  IndiHttpParam({
    String? id,
    String? key,
    String? value,
    bool? enabled,
    String? description,
  })  : id = id ?? const Uuid().v4(),
        key = key ?? '',
        value = value ?? '',
        enabled = enabled ?? true,
        description = description ?? '';

  final String id;
  final String key;
  final String value;
  final bool enabled;
  final String description;

  IndiHttpParam copyWith({
    String? key,
    String? value,
    bool? enabled,
    String? description,
  }) {
    return IndiHttpParam(
      id: id,
      key: key ?? this.key,
      value: value ?? this.value,
      enabled: enabled ?? this.enabled,
      description: description ?? this.description,
    );
  }

  static IndiHttpParam fromJson(final Map<String, dynamic> map) {
    return IndiHttpParam(
      id: map['id'] as String?,
      key: map['key'] as String?,
      value: map['value'] as String?,
      enabled: map['enabled'] as bool?,
      description: map['description'] as String?,
    );
  }

  static String toJson(final IndiHttpParam param) {
    return '''
    {
      "id": "${param.id}",
      "key": "${param.key}",
      "value": "${param.value}",
      "enabled": ${param.enabled},
      "description": "${param.description}"
    }
    ''';
  }
}
