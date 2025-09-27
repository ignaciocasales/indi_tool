import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/core/providers/test_case_provider.dart';

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
      onPressed: () => {
        ref.watch(isTestCaseRunningProvider.notifier).setRunning(!isRunning),
      },
      icon: Icon(isRunning ? Icons.stop : Icons.play_arrow, size: 16),
      label: Text(isRunning ? 'Stop' : 'Start'),
    );
  }
}
