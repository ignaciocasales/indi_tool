import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/providers/data/test_scenarios_prov.dart';
import 'package:indi_tool/providers/navigation/workspace_router_prov.dart';
import 'package:indi_tool/schema/test_scenario.dart';

class NameEditingWidget extends ConsumerStatefulWidget {
  const NameEditingWidget({super.key});

  @override
  ConsumerState<NameEditingWidget> createState() => _NameEditingWidgetState();
}

class _NameEditingWidgetState extends ConsumerState<NameEditingWidget> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();

    final String? scenarioId = ref.read(selectedTestScenarioProvider);

    if (scenarioId == null) {
      throw StateError('No scenario selected');
    }

    ref.read(testScenarioProvider(scenarioId).future).then((scenario) {
      _nameController.text = scenario.name;
    });

    _nameController.addListener(_updateName);
  }

  @override
  void dispose() {
    _nameController.removeListener(_updateName);
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String? scenarioId = ref.watch(selectedTestScenarioProvider);

    if (scenarioId == null) {
      throw StateError('No scenario selected');
    }

    ref.listen(testScenarioProvider(scenarioId), (_, asyncVal) async {
      asyncVal.maybeWhen(
          data: (scenario) {
            if (_nameController.text != scenario.name) {
              _nameController.text = scenario.name;
            }
          },
          orElse: () {});
    });

    return TextField(
      key: Key('name-$scenarioId'),
      controller: _nameController,
      decoration: const InputDecoration(
        isDense: true,
        border: InputBorder.none,
      ),
    );
  }

  void _updateName() async {
    final String name = _nameController.text;

    if (name.isEmpty) {
      return;
    }

    final String? groupId = ref.watch(selectedTestGroupProvider);
    final String? scenarioId = ref.watch(selectedTestScenarioProvider);

    if (scenarioId == null || groupId == null) {
      return;
    }

    final TestScenario scenario =
        await ref.watch(testScenarioProvider(scenarioId).future);

    if (name == scenario.name) {
      return;
    }

    final TestScenario updated = scenario.copyWith(name: name);

    ref.read(testScenariosProvider(groupId).notifier).updateScenario(updated);
  }
}
