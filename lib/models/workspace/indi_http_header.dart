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
}
