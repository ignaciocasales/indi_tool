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
              // Read the needed providers synchronously before any await,
              // to avoid using `ref` after the widget may have been unmounted.
              final testCase = ref.read(selectedTestCaseProvider);
              if (testCase == null) return;
              final runningNotifier = ref.read(
                isTestCaseRunningProvider.notifier,
              );
              final resultsNotifier = ref.read(
                testCaseResultsProvider.notifier,
              );

              runningNotifier.setRunning(true);
              try {
                await resultsNotifier.runFor(testCase);
              } finally {
                // Safe to use the cached notifier instance even if the widget unmounted.
                runningNotifier.setRunning(false);
              }
            },
      icon: Icon(isRunning ? Icons.stop : Icons.play_arrow, size: 16),
      label: Text(isRunning ? 'Running...' : 'Start'),
    );
  }
}
