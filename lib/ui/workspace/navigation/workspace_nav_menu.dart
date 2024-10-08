import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/models/workspace/indi_http_request.dart';
import 'package:indi_tool/models/workspace/test_scenario.dart';
import 'package:indi_tool/providers/navigation/workspace_router_prov.dart';
import 'package:indi_tool/providers/repository/repository_prov.dart';

class WorkspaceNavMenu extends ConsumerWidget {
  const WorkspaceNavMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MenuAnchor(
      builder: (
        BuildContext context,
        MenuController controller,
        Widget? child,
      ) {
        return IconButton(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: const Icon(Icons.add_rounded),
        );
      },
      menuChildren: [
        MenuItemButton(
          child: const Text('Test Scenario'),
          onPressed: () async {
            final int id =
                await ref.read(testScenarioRepositoryProvider).createTestScenario(
                      testScenario: TestScenario(
                        name: 'New Test Scenario',
                        numberOfRequests: 1,
                        threadPoolSize: 1,
                        request: IndiHttpRequest(
                          timeoutMillis: 30000,
                        )
                      ),
                    );

            ref.read(selectedTestScenarioProvider.notifier).select(id);
          },
        ),
      ],
    );
  }
}
