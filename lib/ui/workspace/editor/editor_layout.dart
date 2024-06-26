import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/providers/navigation/workspace_router_prov.dart';
import 'package:indi_tool/ui/workspace/editor/scenarios/scenarios_layout.dart';
import 'package:indi_tool/ui/workspace/editor/groups/group_layout.dart';

class EditorLayout extends ConsumerWidget {
  const EditorLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final TestGroup? group = ref.watch(selectedTestGroupProvider);
    // final TestScenario? scenario = ref.watch(selectedTestScenarioProvider);

    final tuple = (
      ref.watch(selectedTestGroupProvider),
      ref.watch(selectedTestScenarioProvider)
    );

    var layout = switch (tuple) {
      (final group, final scenario) when group != null && scenario == null =>
        const GroupLayout(),
      (final _, final scenario) when scenario != null => const ScenarioLayout(),
      _ => const Center(child: Text('Select an item to view its details')),
    };

    return Expanded(
      flex: 8,
      child: layout,
    );
  }
}
