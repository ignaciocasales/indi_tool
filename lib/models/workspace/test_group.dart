import 'package:indi_tool/models/workspace/test_scenario.dart';

class TestGroup {
  TestGroup({
    this.id,
    String? name,
    String? description,
    List<TestScenario>? testScenarios,
  })  : name = name ?? '',
        description = description ?? '',
        testScenarios = testScenarios ?? [];

  final int? id;
  final String name;
  final String description;
  final List<TestScenario> testScenarios;

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
