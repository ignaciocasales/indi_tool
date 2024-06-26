import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'indi_http_header.g.dart';

@JsonSerializable(
  includeIfNull: false,
  fieldRename: FieldRename.snake,
)
class IndiHttpHeader {
  static const String tableName = 'indi_http_headers';

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

  factory IndiHttpHeader.fromJson(Map<String, dynamic> json) =>
      _$IndiHttpHeaderFromJson(json);

  Map<String, dynamic> toInsert(final String indiHttpRequestId) {
    final map = _$IndiHttpHeaderToJson(this);
    map['indi_http_request_id'] = indiHttpRequestId;
    return map;
  }

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
