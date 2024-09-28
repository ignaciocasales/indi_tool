import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/models/common/body_type.dart';
import 'package:indi_tool/models/workspace/test_scenario.dart';
import 'package:indi_tool/providers/navigation/workspace_router_prov.dart';
import 'package:indi_tool/providers/repository/repository_prov.dart';

class BodyTypeDropdown extends ConsumerStatefulWidget {
  const BodyTypeDropdown({super.key});

  @override
  ConsumerState<BodyTypeDropdown> createState() => _BodyTypeDropdownState();
}

class _BodyTypeDropdownState extends ConsumerState<BodyTypeDropdown> {
  final TextEditingController _controller = TextEditingController();
  bool _enabled = false;

  final _entries =
      BodyType.values.map<DropdownMenuEntry<BodyType>>((BodyType type) {
    return DropdownMenuEntry<BodyType>(
      value: type,
      label: type.name,
    );
  }).toList();

  @override
  void initState() {
    super.initState();
    _controller.text = BodyType.none.name;
    _controller.addListener(_updateType);
  }

  @override
  void dispose() {
    _controller.removeListener(_updateType);
    _controller.dispose();
    super.dispose();
  }

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

      if (_controller.text != data.request.bodyType.name) {
        _controller.text = data.request.bodyType.name;
      }
    });

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownMenu<BodyType>(
        key: Key('body-type-$scenarioId'),
        enabled: _enabled,
        controller: _controller,
        enableFilter: false,
        requestFocusOnTap: false,
        label: const Text('Type'),
        dropdownMenuEntries: _entries,
      ),
    );
  }

  void _updateType() async {
    final String bodyType = _controller.text;

    if (bodyType.isEmpty) {
      return;
    }

    final int? scenarioId = ref.watch(selectedTestScenarioProvider);

    if (scenarioId == null) {
      return;
    }

    final TestScenario scenario =
        await ref.read(testScenarioProvider(scenarioId: scenarioId).future);

    if (bodyType == scenario.request.bodyType.name) {
      return;
    }

    final TestScenario updated = scenario.copyWith(
      request: scenario.request.copyWith(
        bodyType: BodyType.fromString(bodyType),
        body: List<int>.empty(growable: false),
      ),
    );

    ref
        .read(testScenarioRepositoryProvider)
        .updateTestScenario(testScenario: updated);
  }
}
