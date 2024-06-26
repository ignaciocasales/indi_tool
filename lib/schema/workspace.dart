import 'package:indi_tool/schema/test_group.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'workspace.g.dart';

@JsonSerializable(
  includeIfNull: false,
  fieldRename: FieldRename.snake,
)
class Workspace {
  static const String tableName = 'workspaces';

  Workspace({
    String? id,
    String? name,
    String? description,
    List<TestGroup>? testGroups,
  })  : id = id ?? const Uuid().v4(),
        name = name ?? '',
        description = description ?? '',
        testGroups = testGroups ?? List<TestGroup>.empty(growable: true);

  final String id;
  final String name;
  final String description;
  final List<TestGroup> testGroups;

  factory Workspace.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceFromJson(json);

  Map<String, dynamic> toInsert() {
    final map = _$WorkspaceToJson(this);
    map.removeWhere((key, value) => key == 'test_groups');
    return map;
  }

  Workspace copyWith({
    String? name,
    String? description,
    List<TestGroup>? testGroups,
  }) {
    return Workspace(
      name: name ?? this.name,
      description: description ?? this.description,
      testGroups: testGroups ?? this.testGroups,
    );
  }
}
