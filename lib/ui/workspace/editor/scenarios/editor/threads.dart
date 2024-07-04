import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/models/workspace/test_scenario.dart';
import 'package:indi_tool/providers/navigation/workspace_router_prov.dart';
import 'package:indi_tool/providers/repository/repository_prov.dart';

class ThreadsEditingWidget extends ConsumerStatefulWidget {
  const ThreadsEditingWidget({super.key});

  @override
  ConsumerState<ThreadsEditingWidget> createState() =>
      _ThreadsEditingWidgetState();
}

class _ThreadsEditingWidgetState extends ConsumerState<ThreadsEditingWidget> {
  final TextEditingController _controller = TextEditingController();
  bool _enabled = false;
  final int maxValue = 100;
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

      if (_controller.text != data.threadPoolSize.toString()) {
        _controller.text = data.threadPoolSize.toString();
      }
    });

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Tooltip(
          waitDuration: const Duration(milliseconds: 500),
          message:
              'The number of parallel threads to use when making requests.',
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
              labelText: 'Threads',
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
    final String threads = _controller.text;

    if (threads.isEmpty) {
      return;
    }

    final int? scenarioId = ref.watch(selectedTestScenarioProvider);

    if (scenarioId == null) {
      return;
    }

    final TestScenario scenario =
        await ref.read(testScenarioProvider(scenarioId: scenarioId).future);

    if (threads == scenario.threadPoolSize.toString()) {
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
      threadPoolSize: intValue,
    );

    ref
        .read(testScenarioRepositoryProvider)
        .updateTestScenario(testScenario: updated);
  }
}
