import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/core/providers/test_case_provider.dart';
import 'package:indi_tool/core/providers/test_result_provider.dart';

class TestCaseTrigger extends ConsumerStatefulWidget {
  const TestCaseTrigger({super.key});

  @override
  ConsumerState<TestCaseTrigger> createState() => _TestCaseTriggerState();
}

class _TestCaseTriggerState extends ConsumerState<TestCaseTrigger> {
  @override
  Widget build(BuildContext context) {
    final bool isRunning = ref.watch(isTestCaseRunningProvider);

    return ElevatedButton.icon(
      onPressed: isRunning
          ? null
          : () async {
              final testCase = ref.read(selectedTestCaseProvider);
              if (testCase == null) return;
              ref.read(isTestCaseRunningProvider.notifier).setRunning(true);
              try {
                await ref.read(testCaseResultsProvider.notifier).runFor(testCase);
              } finally {
                ref.read(isTestCaseRunningProvider.notifier).setRunning(false);
              }
            },
      icon: Icon(isRunning ? Icons.stop : Icons.play_arrow, size: 16),
      label: Text(isRunning ? 'Running...' : 'Start'),
    );
  }
}
