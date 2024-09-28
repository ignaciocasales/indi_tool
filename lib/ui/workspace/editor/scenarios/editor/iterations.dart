import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/models/workspace/test_scenario.dart';
import 'package:indi_tool/providers/navigation/workspace_router_prov.dart';
import 'package:indi_tool/providers/repository/repository_prov.dart';

class IterationsEditingWidget extends ConsumerStatefulWidget {
  const IterationsEditingWidget({super.key});

  @override
  ConsumerState<IterationsEditingWidget> createState() =>
      _IterationsEditingWidgetState();
}

class _IterationsEditingWidgetState
    extends ConsumerState<IterationsEditingWidget> {
  final TextEditingController _controller = TextEditingController();
  bool _enabled = false;
  final int maxValue = 10000;
  final int minValue = 0;

  @override
  void initState() {
    super.initState();
    _controller.text = '0';
    _controller.addListener(_updateIterations);
  }

  @override
  void dispose() {
    _controller.removeListener(_updateIterations);
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

      if (_controller.text != data.numberOfRequests.toString()) {
        _controller.text = data.numberOfRequests.toString();
      }
    });

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Tooltip(
          waitDuration: const Duration(milliseconds: 500),
          message: 'The total number of requests to be made. These will be '
              'distributed across the threads.',
          child: TextField(
            controller: _controller,
            enabled: _enabled,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              TextInputFormatter.withFunction((o, n) {
                if (n.text.isEmpty) {
                  return o;
                }

                final int? newValueInt = int.tryParse(n.text);
                if (newValueInt == null) {
                  return o;
                }

                if (newValueInt < minValue) {
                  return o;
                }

                if (newValueInt > maxValue) {
                  return o;
                }

                return n;
              }),
            ],
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(
              labelText: 'Iterations',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: const OutlineInputBorder(),
              suffixIcon: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (_controller.text.isEmpty) {
                        return;
                      }

                      int? intValue = int.tryParse(_controller.text);
                      if (intValue == null) {
                        return;
                      }

                      if (intValue >= maxValue) {
                        return;
                      }

                      _controller.text = (intValue + 1).toString();
                    },
                    child: const Icon(Icons.arrow_drop_up),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_controller.text.isEmpty) {
                        return;
                      }

                      int? intValue = int.tryParse(_controller.text);
                      if (intValue == null) {
                        return;
                      }

                      if (intValue <= minValue) {
                        return;
                      }

                      _controller.text = (intValue - 1).toString();
                    },
                    child: const Icon(Icons.arrow_drop_down),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _updateIterations() async {
    final String iterations = _controller.text;

    if (iterations.isEmpty) {
      return;
    }

    final int? scenarioId = ref.watch(selectedTestScenarioProvider);

    if (scenarioId == null) {
      return;
    }

    final TestScenario scenario =
        await ref.read(testScenarioProvider(scenarioId: scenarioId).future);

    if (iterations == scenario.numberOfRequests.toString()) {
      return;
    }

    int? intValue = int.tryParse(_controller.text);

    if (intValue == null) {
      return;
    }

    if (intValue < minValue) {
      return;
    }

    final TestScenario updated = scenario.copyWith(
      numberOfRequests: intValue,
    );

    ref
        .read(testScenarioRepositoryProvider)
        .updateTestScenario(testScenario: updated);
  }
}
