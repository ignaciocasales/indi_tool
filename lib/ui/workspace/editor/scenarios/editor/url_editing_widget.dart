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
  var _enabled = false;

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

  @override
  Widget build(BuildContext context) {
    final int? scenarioId = ref.watch(selectedTestScenarioProvider);

    if (scenarioId == null) {
      throw Exception('No scenario selected');
    }

    ref.listen(indiHttpRequestProvider(scenarioId: scenarioId), (_, asyncVal) {
      asyncVal.whenData((request) {
        if (!_enabled) {
          setState(() {
            _enabled = true;
          });
        }

        if (_urlController.text != request.url) {
          _urlController.text = request.url;
        }
      });
    });

    return TextFormField(
      key: Key('url-$scenarioId'),
      enabled: _enabled,
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
        await ref.read(testScenarioProvider(scenarioId: scenarioId).future);

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
        .read(testScenarioRepositoryProvider)
        .updateTestScenario(testScenario: updated, testGroupId: groupId);
  }
}
