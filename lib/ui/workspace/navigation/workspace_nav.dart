import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/providers/dependencies.dart';
import 'package:indi_tool/ui/workspace/navigation/tree_view.dart';

class WorkspaceNav extends ConsumerWidget {
  const WorkspaceNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  onPressed: () {
                    ref
                        .read(testGroupsProvider.notifier)
                        .add();
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
          const TestGroupsTreeView(),
        ],
      ),
    );
  }
}
