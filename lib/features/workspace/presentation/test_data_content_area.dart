import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/core/providers/navigation_provider.dart';
import 'package:indi_tool/features/response_viewer.dart';
import 'package:indi_tool/features/test_case_metrics.dart';
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

    switch (testCasePage) {
      case TestCasePage.requestBuilder:
        return const TestCaseEditor();
      case TestCasePage.metricsExplorer:
        return const TestCaseMetrics();
      case TestCasePage.responseViewer:
        return const TestCaseResponseViewer();
    }
  }
}
