import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/core/application/global_state_provider.dart';
import 'package:indi_tool/core/application/load_runner_provider.dart';

class TestCaseTrigger extends ConsumerStatefulWidget {
  const TestCaseTrigger({super.key});

  @override
  ConsumerState<TestCaseTrigger> createState() => _TestCaseTriggerState();
}

class _TestCaseTriggerState extends ConsumerState<TestCaseTrigger> {
  @override
  Widget build(BuildContext context) {
    final isRunning = ref.watch(isLoadRunnerRunningStateProvider);

    final asyncTestCase = ref.watch(selectedTestCaseProvider);
    final isReady = asyncTestCase.hasValue && asyncTestCase.value != null;

    final onPressed = !isReady
        ? null
        : isRunning
        ? () {
            stopLoadTest(ref);
          }
        : () {
            final testCase = ref.read(selectedTestCaseProvider).value;
            if (testCase == null) return;
            runLoadTest(ref, testCase);
          };

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(isRunning ? Icons.stop : Icons.play_arrow, size: 16),
      label: Text(isRunning ? 'Stop ' : 'Start'),
    );
  }
}
