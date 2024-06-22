import 'package:indi_tool/schema/indi_http_header.dart';
import 'package:indi_tool/schema/indi_http_param.dart';
import 'package:indi_tool/schema/indi_http_request.dart';
import 'package:indi_tool/schema/test_scenario.dart';
import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

part 'test_group.g.dart';

@embedded
class TestGroup {
  TestGroup({
    required this.id,
    required this.name,
    this.description = '',
    required this.testScenarios,
  });

  final String id;
  final String name;
  final String description;
  final List<TestScenario> testScenarios;

  static TestGroup newWith({
    String? name,
    String? description,
    List<TestScenario>? testScenarios,
  }) {
    return TestGroup(
      id: const Uuid().v4(),
      name: name ?? '',
      description: description ?? '',
      testScenarios: testScenarios ?? List<TestScenario>.empty(growable: true),
    );
  }
}
