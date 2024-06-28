import 'package:indi_tool/data/source/database.dart';
import 'package:indi_tool/models/workspace/test_scenario.dart';

class TestScenarioMapper {
  const TestScenarioMapper._();

  static TestScenario fromEntry(final TestScenarioTableData entry) {
    return TestScenario(
      id: entry.id,
      name: entry.name,
      description: entry.description,
      numberOfRequests: entry.numberOfRequests,
      threadPoolSize: entry.threadPoolSize,
    );
  }
}
