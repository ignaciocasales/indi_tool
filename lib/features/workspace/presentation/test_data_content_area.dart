import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/core/application/global_state_provider.dart';
import 'package:indi_tool/core/application/navigation_provider.dart';
import 'package:indi_tool/core/application/repositories/test_cases_repository_provider.dart';
import 'package:indi_tool/core/domain/models/test_case.dart';
import 'package:indi_tool/features/response_viewer.dart';
import 'package:indi_tool/features/test_case_metrics.dart';
import 'package:indi_tool/features/workspace/components/test_case_top_bar.dart';
import 'package:indi_tool/features/workspace/presentation/test_case_editor.dart';

class TestCaseContentArea extends ConsumerStatefulWidget {
  const TestCaseContentArea({super.key});

  @override
  ConsumerState<TestCaseContentArea> createState() =>
      _TestDataContentAreaState();
}

class _TestDataContentAreaState extends ConsumerState<TestCaseContentArea> {
  @override
  Widget build(BuildContext context) {
    final testCasePage =
        ref.watch(selectedTestPageProvider) ?? TestCasePage.requestBuilder;

    final tcAsync = ref.watch(selectedTestCaseProvider);
    final isReady = tcAsync.hasValue && tcAsync.value != null;
    if (!isReady) {
      return const Center(child: CircularProgressIndicator());
    }
    final tc = tcAsync.value!;

    return Expanded(
      child: Column(
        children: [
          TestCaseTopBar(testCase: tc, onChanged: _onChanged),
          switch (testCasePage) {
            TestCasePage.requestBuilder => TestCaseEditor(
              testCase: tc,
              onChanged: _onChanged,
            ),
            TestCasePage.metricsExplorer => const TestCaseMetrics(),
            TestCasePage.responseViewer => const TestCaseResponseViewer(),
          },
        ],
      ),
    );
  }

  void _onChanged(TestCase updated) {
    ref.read(testCasesRepositoryProvider).update(testCase: updated);
  }
}
