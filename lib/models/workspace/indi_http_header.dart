import 'package:uuid/uuid.dart';

class IndiHttpHeader {
  IndiHttpHeader({
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

  IndiHttpHeader copyWith({
    String? key,
    String? value,
    bool? enabled,
    String? description,
  }) {
    return IndiHttpHeader(
      id: id,
      key: key ?? this.key,
      value: value ?? this.value,
      enabled: enabled ?? this.enabled,
      description: description ?? this.description,
    );
  }

  static IndiHttpHeader fromJson(final Map<String, dynamic> map) {
    return IndiHttpHeader(
      id: map['id'] as String?,
      key: map['key'] as String?,
      value: map['value'] as String?,
      enabled: map['enabled'] as bool?,
      description: map['description'] as String?,
    );
  }

  static String toJson(final IndiHttpHeader header) {
    return '''
    {
      "id": "${header.id}",
      "key": "${header.key}",
      "value": "${header.value}",
      "enabled": ${header.enabled},
      "description": "${header.description}"
    }
    ''';
  }
}
