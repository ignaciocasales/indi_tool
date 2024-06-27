import 'package:indi_tool/models/workspace/test_group.dart';

class Workspace {
  Workspace({
    this.id,
    String? name,
    String? description,
    List<TestGroup>? testGroups,
  })  : name = name ?? '',
        description = description ?? '',
        testGroups = testGroups ?? List<TestGroup>.empty(growable: true);

  final int? id;
  final String name;
  final String description;
  final List<TestGroup> testGroups;

  Workspace copyWith({
    String? name,
    String? description,
    List<TestGroup>? testGroups,
  }) {
    return Workspace(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      testGroups: testGroups ?? this.testGroups,
    );
  }
}
