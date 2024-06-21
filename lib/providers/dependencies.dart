import 'package:indi_tool/models/navigation/work_item.dart';
import 'package:indi_tool/providers/injection/dependency_prov.dart';
import 'package:indi_tool/providers/navigation/work_item_prov.dart';
import 'package:indi_tool/schema/response.dart';
import 'package:indi_tool/schema/test_scenario.dart';
import 'package:indi_tool/services/load_testing.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dependencies.g.dart';

@riverpod
class LoadTestingManager extends _$LoadTestingManager {
  @override
  LoadTestingService build() {
    return ref.read(loadTestingPodProvider);
  }

  Future<List<IndiHttpResponse>> sendRequest() async {
    final WorkItem workItem = ref.watch(selectedWorkItemProvider)!;

    if (workItem.type != WorkItemType.testScenario) {
      throw Exception('No test case selected');
    }

    /*final TestScenario testScenario = ref.watch(testGroupsProvider.select(
        (value) => value.value
            ?.firstWhere((element) => element.id == workItem.parent!.id)
            .testScenarios[workItem.id]))!;*/

    final TestScenario testScenario = TestScenario.newWith();

    return await state.loadTest(testScenario);
  }
}
