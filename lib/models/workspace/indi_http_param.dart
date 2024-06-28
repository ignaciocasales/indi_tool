class IndiHttpParam {
  IndiHttpParam({
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
}
