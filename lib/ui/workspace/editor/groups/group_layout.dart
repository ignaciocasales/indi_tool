import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/core/exceptions/invalid_work_item_type.dart';
import 'package:indi_tool/models/navigation/work_item.dart';
import 'package:indi_tool/providers/data/test_groups_prov.dart';
import 'package:indi_tool/providers/data/test_scenarios_prov.dart';
import 'package:indi_tool/providers/navigation/work_item_prov.dart';
import 'package:indi_tool/schema/test_group.dart';

class GroupLayout extends ConsumerWidget {
  const GroupLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final WorkItem workItem = ref.watch(selectedWorkItemProvider)!;

    if (workItem.type != WorkItemType.testGroup) {
      throw InvalidWorkItemType(workItem.type);
    }

    final TestGroup? testGroup = ref.watch(testGroupsProvider.select((value) {
      if (value.value == null || value.value!.isEmpty) {
        return null;
      }

      return value.value!.firstWhere((element) => element.id == workItem.id);
    }));

    if (testGroup == null) {
      return const SizedBox();
    }

    return Column(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(testGroup.name),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  ref.read(testScenariosProvider.notifier).addTestScenario(testGroup);
                },
                child: const Text('Add a Test Case'),
              ),
            ],
          ),
        )
      ],
    );
  }
}
