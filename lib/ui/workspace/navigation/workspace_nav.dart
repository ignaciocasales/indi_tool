import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/models/navigation/work_item.dart';
import 'package:indi_tool/providers/data/test_groups_prov.dart';
import 'package:indi_tool/providers/data/workspace_prov.dart';
import 'package:indi_tool/providers/data/workspaces_prov.dart';
import 'package:indi_tool/providers/navigation/work_item_prov.dart';
import 'package:indi_tool/schema/test_group.dart';
import 'package:indi_tool/schema/workspace.dart';
import 'package:indi_tool/ui/workspace/navigation/workspace_nav_tree.dart';

class WorkspaceNav extends ConsumerWidget {
  const WorkspaceNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int id = ref.watch(selectedWorkspaceProvider)!;
    final Workspace workspace = ref.watch(workspacesProvider
        .select((e) => e.value?.firstWhere((e) => e.id == id)))!;

    return Expanded(
      flex: 2,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    final TestGroup testGroup = await ref
                        .read(testGroupsProvider.notifier)
                        .addTestGroup(workspace);

                    ref.read(selectedWorkItemProvider.notifier).select(
                          WorkItem(
                            id: testGroup.id,
                            type: WorkItemType.testGroup,
                          ),
                        );
                  },
                  child: const Row(
                    children: [
                      Text('Add Group'),
                      Icon(Icons.add),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const MinimalTreeView(),
        ],
      ),
    );
  }
}
