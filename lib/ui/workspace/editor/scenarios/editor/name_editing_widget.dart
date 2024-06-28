import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/models/workspace/test_scenario.dart';
import 'package:indi_tool/providers/navigation/workspace_router_prov.dart';
import 'package:indi_tool/providers/repository/repository_prov.dart';

class NameEditingWidget extends ConsumerStatefulWidget {
  const NameEditingWidget({super.key});

  @override
  ConsumerState<NameEditingWidget> createState() => _NameEditingWidgetState();
}

class _NameEditingWidgetState extends ConsumerState<NameEditingWidget> {
  late TextEditingController _nameController;
  bool _enabled = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();

    final int? scenarioId = ref.read(selectedTestScenarioProvider);

    if (scenarioId == null) {
      throw StateError('No scenario selected');
    }

    ref
        .read(testScenarioProvider(scenarioId: scenarioId).future)
        .then((scenario) {
      _nameController.text = scenario.name;
      _enabled = true;
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
    final int? scenarioId = ref.watch(selectedTestScenarioProvider);

    if (scenarioId == null) {
      throw StateError('No scenario selected');
    }

    ref.listen(testScenarioProvider(scenarioId: scenarioId),
        (_, asyncVal) async {
      asyncVal.whenData((scenario) {
        if (!_enabled) {
          setState(() {
            _enabled = true;
          });
        }

        if (_nameController.text != scenario.name) {
          _nameController.text = scenario.name;
        }
      });
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

    final int? groupId = ref.watch(selectedTestGroupProvider);
    final int? scenarioId = ref.watch(selectedTestScenarioProvider);

    if (scenarioId == null || groupId == null) {
      return;
    }

    final TestScenario scenario =
        await ref.read(testScenarioProvider(scenarioId: scenarioId).future);

    if (name == scenario.name) {
      return;
    }

    final TestScenario updated = scenario.copyWith(name: name);

    ref
        .read(testScenarioRepositoryProvider)
        .updateTestScenario(testScenario: updated, testGroupId: groupId);
  }
}
