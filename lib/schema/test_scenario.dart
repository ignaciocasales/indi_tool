import 'package:isar/isar.dart';

part 'test_scenario.g.dart';

@embedded
class TestScenario {
  int id;
  String name;
  String description;
  int numberOfRequests;
  int threadPoolSize;

  TestScenario(
    this.id,
    this.name,
    this.description,
    this.numberOfRequests,
    this.threadPoolSize,
  );
}
