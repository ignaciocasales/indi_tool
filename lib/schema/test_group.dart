import 'package:indi_tool/schema/test_scenario.dart';
import 'package:isar/isar.dart';

part 'test_group.g.dart';

@collection
class TestGroup {
  TestGroup({
    required this.id,
    required this.name,
    required this.description,
    required this.testCases,
  });

  final int id;
  final String name;
  final String description;
  final List<TestScenario> testCases;
}
