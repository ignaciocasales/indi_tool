import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/providers/navigation/workspace_router_prov.dart';
import 'package:indi_tool/ui/workspace/editor/scenarios/scenario_layout.dart';

class EditorLayout extends ConsumerWidget {
  const EditorLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedTestScenarioProvider);

    var layout = switch (selected) {
      (final scenario) when scenario != null => const ScenarioLayout(),
      _ => const Center(child: Text('Select an item to view its details')),
    };

    return Expanded(
      flex: 8,
      child: layout,
    );
  }
}
