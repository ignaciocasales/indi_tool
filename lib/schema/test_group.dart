import 'package:indi_tool/schema/request.dart';
import 'package:indi_tool/schema/request_header.dart';
import 'package:indi_tool/schema/request_param.dart';
import 'package:indi_tool/schema/test_scenario.dart';
import 'package:isar/isar.dart';

part 'test_group.g.dart';

@collection
class TestGroup {
  TestGroup({
    required this.id,
    required this.name,
    this.description = '',
    required this.testScenarios,
  });

  final int id;
  final String name;
  final String description;
  final List<TestScenario> testScenarios;
}
