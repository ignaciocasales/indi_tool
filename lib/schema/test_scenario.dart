import 'package:indi_tool/schema/indi_http_request.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'test_scenario.g.dart';

@JsonSerializable(
  includeIfNull: false,
  fieldRename: FieldRename.snake,
)
class TestScenario {
  static const String tableName = 'test_scenarios';

  TestScenario({
    String? id,
    String? name,
    String? description,
    int? numberOfRequests,
    int? threadPoolSize,
    IndiHttpRequest? request,
  })  : id = id ?? const Uuid().v4(),
        name = name ?? '',
        description = description ?? '',
        numberOfRequests = numberOfRequests ?? 1,
        threadPoolSize = threadPoolSize ?? 1,
        request = request ?? IndiHttpRequest();

  final String id;
  final String name;
  final String description;
  final int numberOfRequests;
  final int threadPoolSize;
  final IndiHttpRequest request;

  factory TestScenario.fromJson(Map<String, dynamic> json) =>
      _$TestScenarioFromJson(json);

  Map<String, dynamic> toInsert(final String testGroupId) {
    final map = _$TestScenarioToJson(this);
    map.removeWhere((key, value) => key == 'request');
    map['test_group_id'] = testGroupId;
    return map;
  }

  TestScenario copyWith({
    String? name,
    String? description,
    int? numberOfRequests,
    int? threadPoolSize,
    IndiHttpRequest? request,
  }) {
    return TestScenario(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      numberOfRequests: numberOfRequests ?? this.numberOfRequests,
      threadPoolSize: threadPoolSize ?? this.threadPoolSize,
      request: request ?? this.request,
    );
  }
}
