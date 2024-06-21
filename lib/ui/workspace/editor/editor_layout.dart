import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/models/navigation/work_item.dart';
import 'package:indi_tool/providers/navigation/work_item_prov.dart';
import 'package:indi_tool/ui/workspace/editor/cases/case_layout.dart';
import 'package:indi_tool/ui/workspace/editor/groups/group_layout.dart';

class EditorLayout extends ConsumerWidget {
  const EditorLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final WorkItem? workItem = ref.watch(selectedWorkItemProvider);

    var layout = switch (workItem) {
      WorkItem(type: final type) when type == WorkItemType.testGroup =>
        const GroupLayout(),
      WorkItem(type: final type) when type == WorkItemType.testScenario =>
        const CaseLayout(),
      null => const Center(child: Text('Select a request to view details')),
      _ => throw Exception('Invalid work item type'),
    };

    return Expanded(
      flex: 8,
      child: layout,
    );
  }
}
