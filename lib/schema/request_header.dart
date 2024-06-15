import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

part 'request_header.g.dart';

@embedded
class IndiHttpHeader {
  IndiHttpHeader({
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

  static IndiHttpHeader newWith({
    String? key,
    String? value,
    bool? enabled,
    String? description,
  }) {
    return IndiHttpHeader(
      id: const Uuid().v4(),
      key: key ?? '',
      value: value ?? '',
      enabled: enabled ?? true,
      description: description ?? '',
    );
  }
}