import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/providers/data/test_scenarios_prov.dart';
import 'package:indi_tool/providers/navigation/workspace_router_prov.dart';
import 'package:indi_tool/schema/indi_http_param.dart';
import 'package:indi_tool/schema/test_scenario.dart';
import 'package:indi_tool/services/params_builder.dart';

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

    final String? scenarioId = ref.read(selectedTestScenarioProvider);

    if (scenarioId == null) {
      throw StateError('No scenario selected');
    }

    ref.read(testScenarioProvider(scenarioId).future).then((scenario) {
      _urlController.text = scenario.request.url;
    });

    _urlController.addListener(_updateUrl);
  }

  @override
  void dispose() {
    _urlController.removeListener(_updateUrl);
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String? scenarioId = ref.watch(selectedTestScenarioProvider);

    if (scenarioId == null) {
      throw StateError('No scenario selected');
    }

    ref.listen(testScenarioProvider(scenarioId), (_, asyncVal) {
      asyncVal.whenData((scenario) {
        if (_urlController.text != scenario.request.url) {
          _urlController.text = scenario.request.url;
        }
      });
    });

    return TextFormField(
      key: Key('url-$scenarioId'),
      controller: _urlController,
      decoration: const InputDecoration(
        hintText: 'Enter URL',
        border: InputBorder.none,
      ),
    );
  }

  void _updateUrl() async {
    final String url = _urlController.text;

    if (url.isEmpty) {
      return;
    }

    final String? groupId = ref.watch(selectedTestGroupProvider);
    final String? scenarioId = ref.watch(selectedTestScenarioProvider);

    if (scenarioId == null || groupId == null) {
      return;
    }

    final TestScenario scenario =
        await ref.watch(testScenarioProvider(scenarioId).future);

    if (url == scenario.request.url) {
      return;
    }

    final List<IndiHttpParam> parameters = ParamsBuilder.syncWithUrl(
      url,
      scenario.request.parameters,
    );

    final TestScenario updated = scenario.copyWith(
      request: scenario.request.copyWith(url: url, parameters: parameters),
    );

    ref.read(testScenariosProvider(groupId).notifier).updateScenario(updated);
  }
}
