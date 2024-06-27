import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/providers/navigation/workspace_router_prov.dart';
import 'package:indi_tool/models/workspace/test_group.dart';
import 'package:indi_tool/providers/repository/repository_prov.dart';

class WorkspaceNavMenu extends ConsumerWidget {
  const WorkspaceNavMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int? workspaceId = ref.watch(selectedWorkspaceProvider);

    if (workspaceId == null) {
      throw StateError('No workspace selected');
    }

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
          child: const Text('Test Group'),
          onPressed: () async {
            final int id = await ref
                .read(testGroupsRepositoryProvider.notifier)
                .createTestGroup(TestGroup(
                  name: 'New Test Group',
                ));

            ref.read(selectedTestGroupProvider.notifier).select(id);
          },
        ),
      ],
    );
  }
}
