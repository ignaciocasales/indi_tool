import 'package:indi_tool/schema/test_group.dart';
import 'package:indi_tool/schema/test_scenario.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dependencies.g.dart';

@riverpod
Future<Isar> isar(IsarRef ref) async {
  final dir = await getApplicationDocumentsDirectory();
  return Isar.open(
    schemas: [TestGroupSchema],
    directory: dir.path,
  );
}

@riverpod
class TestGroups extends _$TestGroups {
  @override
  Future<List<TestGroup>> build() async {
    final Isar isar = await ref.watch(isarProvider.future);
    return isar.testGroups.where().findAll();
  }

  Future<void> add() async {
    final Isar isar = await ref.watch(isarProvider.future);

    final newTestGroup = TestGroup(
      id: isar.testGroups.autoIncrement(),
      name: 'New Test Group',
      description: '',
      testCases: [],
    );

    isar.write((isar) async {
      isar.testGroups.put(newTestGroup);
    });

    state = AsyncValue.data(isar.testGroups.where().findAll());
  }

  Future<TestGroup> get(int id) async {
    final Isar isar = await ref.watch(isarProvider.future);
    return isar.testGroups.get(id)!;
  }

  Future<void> addTestCase(int id) async {
    final Isar isar = await ref.watch(isarProvider.future);

    final newTestCase = TestScenario(0, 'New Test Case', '', 1, 1);

    isar.write((isar) async {
      final testGroup = isar.testGroups.get(id)!;
      testGroup.testCases.add(newTestCase);
      isar.testGroups.put(testGroup);
    });

    state = AsyncValue.data(isar.testGroups.where().findAll());
  }
}

@riverpod
class SelectedWorkItem extends _$SelectedWorkItem {
  @override
  WorkItem? build() {
    return null;
  }

  void select(WorkItem workItem) {
    state = workItem;
  }
}

class WorkItem {
  final int id;
  final WorkItemType type;

  WorkItem({
    required this.id,
    required this.type,
  });
}

enum WorkItemType {
  testGroup,
  testCase,
}
