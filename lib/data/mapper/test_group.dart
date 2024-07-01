import 'package:indi_tool/data/source/database.dart';
import 'package:indi_tool/models/workspace/test_group.dart';

class TestGroupMapper {
  const TestGroupMapper._();

  static TestGroup fromEntry(final TestGroupTableData entry) {
    return TestGroup(
      id: entry.id,
      name: entry.name,
      description: entry.description,
    );
  }
}
