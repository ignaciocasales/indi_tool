import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/core/application/global_state_provider.dart';
import 'package:indi_tool/features/home/components/indi_app_bar.dart';
import 'package:indi_tool/features/home/components/indi_sidebar.dart';
import 'package:indi_tool/features/home/presentation/clear_content_area.dart';
import 'package:indi_tool/features/workspace/presentation/test_case_view.dart';

class IndiHomePage extends ConsumerStatefulWidget {
  const IndiHomePage({super.key});

  @override
  ConsumerState<IndiHomePage> createState() => _IndiHomePageState();
}

class _IndiHomePageState extends ConsumerState<IndiHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: indiAppBar(context: context),
      body: const Row(
        children: [IndiSidebar(flex: 1), MainContentArea(flex: 4)],
      ),
    );
  }
}

class MainContentArea extends ConsumerStatefulWidget {
  const MainContentArea({super.key, required this.flex});

  final int flex;

  @override
  ConsumerState<MainContentArea> createState() => _MainContentAreaState();
}

class _MainContentAreaState extends ConsumerState<MainContentArea> {
  @override
  Widget build(BuildContext context) {
    final id = ref.watch(selectedTestCaseIdProvider);
    return Expanded(
      flex: widget.flex,
      child: id == null ? const ClearContentArea() : const TestCaseView(),
    );
  }
}
