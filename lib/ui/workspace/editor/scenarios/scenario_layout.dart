import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/models/workspace/test_scenario.dart';
import 'package:indi_tool/providers/navigation/workspace_router_prov.dart';
import 'package:indi_tool/providers/repository/repository_prov.dart';
import 'package:indi_tool/providers/services/load_testing_prov.dart';
import 'package:indi_tool/ui/workspace/editor/scenarios/editor/name.dart';
import 'package:indi_tool/ui/workspace/editor/scenarios/editor/url.dart';
import 'package:indi_tool/ui/workspace/editor/scenarios/editor/http_method.dart';
import 'package:indi_tool/ui/workspace/editor/scenarios/request_editor_nav.dart';
import 'package:indi_tool/ui/workspace/editor/scenarios/response_layout.dart';
import 'package:indi_tool/ui/workspace/editor/scenarios/result/results_widget.dart';

class ScenarioLayout extends ConsumerWidget {
  const ScenarioLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int? scenarioId = ref.watch(selectedTestScenarioProvider);

    if (scenarioId == null) {
      throw StateError('No scenario selected');
    }

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: NameEditingWidget(),
        ),
        const Divider(height: 0),
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: HttpMethodEditingWidget(),
            ),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: UrlEditingWidget(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FilledButton(
                onPressed: () async {
                  final TestScenario scenario = await ref.read(
                      testScenarioProvider(scenarioId: scenarioId).future);

                  ref
                      .read(loadTestingProvider.notifier)
                      .startLoadTest(scenario);
                },
                child: const Row(
                  children: [
                    Text('Start'),
                    Icon(Icons.play_arrow),
                  ],
                ),
              ),
            )
          ],
        ),
        const Divider(
          height: 0,
        ),
        const Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RequestEditorNav(),
              VerticalDivider(
                width: 0,
              ),
              ResponseLayout(),
            ],
          ),
        ),
        const Divider(
          height: 0,
        ),
        const Expanded(
          child: Row(
            children: [
              ResultsWidget(),
            ],
          ),
        ),
      ],
    );
  }
}
