import 'package:indi_tool/schema/test_scenario.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'test_group.g.dart';

@JsonSerializable(
  includeIfNull: false,
  fieldRename: FieldRename.snake,
)
class TestGroup {
  static const String tableName = 'test_groups';

  TestGroup({
    String? id,
    String? name,
    String? description,
    List<TestScenario>? testScenarios,
  })  : id = id ?? const Uuid().v4(),
        name = name ?? '',
        description = description ?? '',
        testScenarios = testScenarios ?? [];

  final String id;
  final String name;
  final String description;
  final List<TestScenario> testScenarios;

  factory TestGroup.fromJson(Map<String, dynamic> json) =>
      _$TestGroupFromJson(json);

  Map<String, dynamic> toInsert(final String workspaceId) {
    final map = _$TestGroupToJson(this);
    map.removeWhere((key, value) => key == 'test_scenarios');
    map['workspace_id'] = workspaceId;
    return map;
  }

  TestGroup copyWith({
    String? name,
    String? description,
    List<TestScenario>? testScenarios,
  }) {
    return TestGroup(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      testScenarios: testScenarios ?? this.testScenarios,
    );
  }
}
