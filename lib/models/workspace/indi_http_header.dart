class IndiHttpHeader {
  IndiHttpHeader({
    this.id,
    String? key,
    String? value,
    bool? enabled,
    String? description,
  })  : key = key ?? '',
        value = value ?? '',
        enabled = enabled ?? true,
        description = description ?? '';

  final int? id;
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

  static IndiHttpHeader fromJson(Map<String, dynamic> map) {
    return IndiHttpHeader(
      id: map['id'] as int?,
      key: map['key'] as String?,
      value: map['value'] as String?,
      enabled: map['enabled'] as bool?,
      description: map['description'] as String?,
    );
  }

  static String toJson(IndiHttpHeader header) {
    return '''
    {
      "id": ${header.id},
      "key": "${header.key}",
      "value": "${header.value}",
      "enabled": ${header.enabled},
      "description": "${header.description}",
    }
    ''';
  }
}
