import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/models/workspace/indi_http_param.dart';
import 'package:indi_tool/models/workspace/test_scenario.dart';
import 'package:indi_tool/providers/navigation/workspace_router_prov.dart';
import 'package:indi_tool/providers/repository/repository_prov.dart';
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

    final int? scenarioId = ref.read(selectedTestScenarioProvider);

    if (scenarioId == null) {
      throw StateError('No scenario selected');
    }

    ref.read(testScenarioRepositoryProvider().future).then((scenario) {
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
    final int? scenarioId = ref.watch(selectedTestScenarioProvider);

    if (scenarioId == null) {
      throw StateError('No scenario selected');
    }

    ref.listen(testScenarioRepositoryProvider(), (_, asyncVal) {
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

    final int? groupId = ref.watch(selectedTestGroupProvider);
    final int? scenarioId = ref.watch(selectedTestScenarioProvider);

    if (scenarioId == null || groupId == null) {
      return;
    }

    final TestScenario scenario =
        await ref.read(testScenarioRepositoryProvider().future);

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

    ref
        .read(testScenariosRepositoryProvider().notifier)
        .updateTestScenario(updated);
  }
}
