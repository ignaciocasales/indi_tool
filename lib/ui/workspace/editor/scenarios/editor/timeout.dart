import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/models/workspace/test_scenario.dart';
import 'package:indi_tool/providers/navigation/workspace_router_prov.dart';
import 'package:indi_tool/providers/repository/repository_prov.dart';

class TimeoutEditingWidget extends ConsumerStatefulWidget {
  const TimeoutEditingWidget({super.key});

  @override
  ConsumerState<TimeoutEditingWidget> createState() =>
      _TimeoutEditingWidgetState();
}

class _TimeoutEditingWidgetState extends ConsumerState<TimeoutEditingWidget> {
  final TextEditingController _controller = TextEditingController();
  bool _enabled = false;
  final int maxValue = 100000000;
  final int minValue = 0;

  @override
  void initState() {
    super.initState();
    _controller.text = '0';
    _controller.addListener(_updateTimeout);
  }

  @override
  void dispose() {
    _controller.removeListener(_updateTimeout);
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

      if (_controller.text != data.request.timeoutMillis.toString()) {
        _controller.text = data.request.timeoutMillis.toString();
      }
    });

    return Expanded(
      flex: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Tooltip(
          waitDuration: const Duration(milliseconds: 500),
          message: 'The maximum time to wait for a response from the server.',
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
              labelText: 'Timeout (ms)',
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

  void _updateTimeout() async {
    final String timeout = _controller.text;

    if (timeout.isEmpty) {
      return;
    }

    final int? scenarioId = ref.watch(selectedTestScenarioProvider);

    if (scenarioId == null) {
      return;
    }

    final TestScenario scenario =
        await ref.read(testScenarioProvider(scenarioId: scenarioId).future);

    if (timeout == scenario.request.timeoutMillis.toString()) {
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
      request: scenario.request.copyWith(timeoutMillis: intValue),
    );

    ref
        .read(testScenarioRepositoryProvider)
        .updateTestScenario(testScenario: updated);
  }
}
