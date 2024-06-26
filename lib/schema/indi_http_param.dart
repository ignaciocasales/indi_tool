import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'indi_http_param.g.dart';

@JsonSerializable(
  includeIfNull: false,
  fieldRename: FieldRename.snake,
)
class IndiHttpParam {
  static const String tableName = 'indi_http_params';

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

  factory IndiHttpParam.fromJson(Map<String, dynamic> json) =>
      _$IndiHttpParamFromJson(json);

  Map<String, dynamic> toInsert(final String indiHttpRequestId) {
    final map = _$IndiHttpParamToJson(this);
    map['indi_http_request_id'] = indiHttpRequestId;
    return map;
  }

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
