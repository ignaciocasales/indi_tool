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
}
