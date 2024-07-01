import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/models/common/http_method.dart';
import 'package:indi_tool/models/workspace/test_scenario.dart';
import 'package:indi_tool/providers/navigation/workspace_router_prov.dart';
import 'package:indi_tool/providers/repository/repository_prov.dart';

class HttpMethodEditingWidget extends ConsumerStatefulWidget {
  const HttpMethodEditingWidget({super.key});

  @override
  ConsumerState<HttpMethodEditingWidget> createState() =>
      _HttpMethodEditingWidgetState();
}

class _HttpMethodEditingWidgetState
    extends ConsumerState<HttpMethodEditingWidget> {
  late final TextEditingController _controller;
  bool _enabled = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.text = HttpMethod.get.name;
    _controller.addListener(_updateMethod);
  }

  @override
  void dispose() {
    _controller.removeListener(_updateMethod);
    _controller.dispose();
    super.dispose();
  }

  final List<DropdownMenuEntry<HttpMethod>> _entries =
      HttpMethod.values.map<DropdownMenuEntry<HttpMethod>>(
    (HttpMethod type) {
      return DropdownMenuEntry<HttpMethod>(
        value: type,
        label: type.name,
      );
    },
  ).toList();

  @override
  Widget build(BuildContext context) {
    final int? scenarioId = ref.watch(selectedTestScenarioProvider);

    if (scenarioId == null) {
      throw StateError('No scenario selected');
    }

    ref.watch(testScenarioProvider(scenarioId: scenarioId)).whenData((data) {
      if (!_enabled) {
        setState(() {
          _enabled = true;
        });
      }

      if (_controller.text != data.request.method.name) {
        _controller.text = data.request.method.name;
      }
    });

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownMenu<HttpMethod>(
        key: Key('method-$scenarioId'),
        controller: _controller,
        enableFilter: false,
        requestFocusOnTap: false,
        dropdownMenuEntries: _entries,
        // onSelected: onSelected,
        inputDecorationTheme: const InputDecorationTheme(
          border: InputBorder.none,
        ),
      ),
    );
  }

  void _updateMethod() async {
    final String method = _controller.text;

    if (method.isEmpty) {
      return;
    }

    final int? groupId = ref.watch(selectedTestGroupProvider);
    final int? scenarioId = ref.watch(selectedTestScenarioProvider);

    if (scenarioId == null || groupId == null) {
      return;
    }

    final TestScenario scenario =
        await ref.read(testScenarioProvider(scenarioId: scenarioId).future);

    if (method == scenario.request.method.name) {
      return;
    }

    final TestScenario updated = scenario.copyWith(
      request: scenario.request.copyWith(method: HttpMethod.fromString(method)),
    );

    ref
        .read(testScenarioRepositoryProvider)
        .updateTestScenario(testScenario: updated, testGroupId: groupId);
  }
}
