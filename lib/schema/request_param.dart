import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

part 'request_param.g.dart';

@embedded
class IndiHttpParameter {
  IndiHttpParameter({
    required this.id,
    this.key = '',
    this.value = '',
    this.enabled = true,
    this.description = '',
  });

  final String id;
  final String key;
  final String value;
  final bool enabled;
  final String description;

  IndiHttpParameter copyWith({
    String? key,
    String? value,
    bool? enabled,
    String? description,
  }) {
    return IndiHttpParameter(
      id: id,
      key: key ?? this.key,
      value: value ?? this.value,
      enabled: enabled ?? this.enabled,
      description: description ?? this.description,
    );
  }

  static IndiHttpParameter newWith({
    String? key,
    String? value,
    bool? enabled,
    String? description,
  }) {
    return IndiHttpParameter(
      id: const Uuid().v4(),
      key: key ?? '',
      value: value ?? '',
      enabled: enabled ?? true,
      description: description ?? '',
    );
  }

  bool hasValue() {
    return key.isNotEmpty ||
        value.isNotEmpty ||
        description.isNotEmpty ||
        enabled;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IndiHttpParameter &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          key == other.key &&
          value == other.value &&
          enabled == other.enabled &&
          description == other.description;

  @override
  int get hashCode =>
      id.hashCode ^
      key.hashCode ^
      value.hashCode ^
      enabled.hashCode ^
      description.hashCode;
}
