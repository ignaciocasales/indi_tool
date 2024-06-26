import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/providers/data/test_groups_prov.dart';
import 'package:indi_tool/providers/data/test_scenarios_prov.dart';
import 'package:indi_tool/providers/navigation/workspace_router_prov.dart';
import 'package:indi_tool/schema/test_group.dart';
import 'package:indi_tool/schema/test_scenario.dart';

class GroupLayout extends ConsumerWidget {
  const GroupLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String? groupId = ref.watch(selectedTestGroupProvider);

    if (groupId == null) {
      throw StateError('No group selected');
    }

    final AsyncValue<TestGroup> asyncGroup =
        ref.watch(testGroupProvider(groupId));

    return asyncGroup.when(
      data: (group) {
        return Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(group.name),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(testScenariosProvider(groupId).notifier)
                          .addScenario(TestScenario(name: 'New Scenario'));
                    },
                    child: const Text('Add a Test Case'),
                  ),
                ],
              ),
            )
          ],
        );
      },
      error: (err, st) {
        return const Text('Error loading group');
      },
      loading: () {
        return const LinearProgressIndicator();
      },
    );
  }
}
