import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/providers/data/test_scenarios_prov.dart';
import 'package:indi_tool/providers/navigation/work_item_prov.dart';
import 'package:indi_tool/providers/services/load_testing_prov.dart';
import 'package:indi_tool/schema/indi_http_param.dart';
import 'package:indi_tool/schema/test_scenario.dart';
import 'package:indi_tool/services/params_builder.dart';
import 'package:indi_tool/ui/workspace/editor/cases/chart/chart.dart';
import 'package:indi_tool/ui/workspace/editor/cases/http_dropdown.dart';
import 'package:indi_tool/ui/workspace/editor/cases/request_editor_nav.dart';
import 'package:indi_tool/ui/workspace/editor/cases/response_layout.dart';

class CaseLayout extends ConsumerWidget {
  const CaseLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: HttpMethodDropdown(),
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
                onPressed: () {
                  // Do something
                  ref.read(loadTestingManagerProvider.notifier).sendRequest();
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
              ChartWidget(),
            ],
          ),
        ),
      ],
    );
  }
}

class UrlEditingWidget extends ConsumerStatefulWidget {
  const UrlEditingWidget({super.key});

  @override
  ConsumerState<UrlEditingWidget> createState() => _UrlEditingWidgetState();
}

class _UrlEditingWidgetState extends ConsumerState<UrlEditingWidget> {
  late TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController();
    _urlController.addListener(_updateUrl);
  }

  @override
  void dispose() {
    _urlController.removeListener(_updateUrl);
    _urlController.dispose();
    super.dispose();
  }

  void _updateUrl() {
    final String url = _urlController.text;

    final workItem = ref.read(selectedWorkItemProvider)!;

    final TestScenario testScenario = ref.watch(testScenariosProvider
        .select((q) => q.value?.firstWhere((e) => e.id == workItem.id)))!;

    final List<IndiHttpParam> parameters = ParamsBuilder.syncWithUrl(
      url,
      testScenario.request.parameters,
    );

    final TestScenario updated = testScenario.copyWith(
      request: testScenario.request.copyWith(url: url, parameters: parameters),
    );

    ref.read(testScenariosProvider.notifier).updateTestScenario(updated);
  }

  @override
  Widget build(BuildContext context) {
    final workItem = ref.watch(selectedWorkItemProvider)!;

    final TestScenario? testScenario =
        ref.watch(testScenariosProvider.select((value) {
      if (value.value == null || value.value!.isEmpty) {
        return null;
      }

      return value.value?.firstWhere((element) => element.id == workItem.id);
    }));

    if (testScenario == null) {
      return const SizedBox();
    }

    if (_urlController.text != testScenario.request.url) {
      _urlController.text = testScenario.request.url;
    }

    return TextFormField(
      key: Key('url-${workItem.id}'),
      controller: _urlController,
      decoration: const InputDecoration(
        hintText: 'Enter URL',
        border: InputBorder.none,
      ),
    );
  }
}
