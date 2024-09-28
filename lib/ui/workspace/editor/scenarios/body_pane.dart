import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/models/common/body_type.dart';
import 'package:indi_tool/providers/navigation/workspace_router_prov.dart';
import 'package:indi_tool/providers/repository/repository_prov.dart';
import 'package:indi_tool/ui/workspace/editor/scenarios/editor/body_raw.dart';
import 'package:indi_tool/ui/workspace/editor/scenarios/editor/body_type.dart';

class Body extends ConsumerWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int? scenarioId = ref.watch(selectedTestScenarioProvider);

    if (scenarioId == null) {
      throw StateError('No scenario selected');
    }

    final asyncScenario =
        ref.watch(testScenarioProvider(scenarioId: scenarioId));

    final Widget body = switch (asyncScenario) {
      AsyncData(value: final scenario)
          when scenario.request.bodyType == BodyType.raw =>
        const RawBodyEditingWidget(),
      _ => const SizedBox(),
    };

    return Column(
      children: [
        const Row(
          children: [
            BodyTypeDropdown(),
          ],
        ),
        body,
      ],
    );
  }
}
