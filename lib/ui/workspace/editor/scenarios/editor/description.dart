import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/models/workspace/test_scenario.dart';
import 'package:indi_tool/providers/navigation/workspace_router_prov.dart';
import 'package:indi_tool/providers/repository/repository_prov.dart';

class DescriptionEditingWidget extends ConsumerStatefulWidget {
  const DescriptionEditingWidget({super.key});

  @override
  ConsumerState<DescriptionEditingWidget> createState() =>
      _DescriptionEditingWidgetState();
}

class _DescriptionEditingWidgetState
    extends ConsumerState<DescriptionEditingWidget> {
  final TextEditingController _controller = TextEditingController();
  bool _enabled = false;

  @override
  void initState() {
    super.initState();
    _controller.text = '';
    _controller.addListener(_updateDescription);
  }

  @override
  void dispose() {
    _controller.removeListener(_updateDescription);
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

      if (_controller.text != data.description) {
        _controller.text = data.description;
      }
    });

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: _controller,
          enabled: _enabled,
          expands: true,
          maxLines: null,
          textAlignVertical: TextAlignVertical.top,
          decoration: const InputDecoration(
            labelText: 'Description',
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  void _updateDescription() async {
    final String description = _controller.text;

    final int? scenarioId = ref.watch(selectedTestScenarioProvider);

    if (scenarioId == null) {
      return;
    }

    final TestScenario scenario =
        await ref.read(testScenarioProvider(scenarioId: scenarioId).future);

    if (description == scenario.description) {
      return;
    }

    final TestScenario updated = scenario.copyWith(
      description: description,
    );

    ref
        .read(testScenarioRepositoryProvider)
        .updateTestScenario(testScenario: updated);
  }
}
