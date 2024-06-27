import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/models/workspace/test_group.dart';
import 'package:indi_tool/models/workspace/test_scenario.dart';
import 'package:indi_tool/providers/navigation/workspace_router_prov.dart';
import 'package:indi_tool/providers/repository/repository_prov.dart';

class GroupLayout extends ConsumerWidget {
  const GroupLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int? groupId = ref.watch(selectedTestGroupProvider);

    if (groupId == null) {
      throw StateError('No group selected');
    }

    final AsyncValue<TestGroup> asyncGroup =
        ref.watch(testGroupRepositoryProvider(groupId));

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
                    onPressed: () async {
                      final int id = await ref
                          .read(testScenariosRepositoryProvider().notifier)
                          .createTestScenario(TestScenario(name: 'New Scenario'));

                      ref
                          .read(selectedTestScenarioProvider.notifier)
                          .select(id);
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
