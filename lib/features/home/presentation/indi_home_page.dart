import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/features/home/components/indi_app_bar.dart';
import 'package:indi_tool/features/home/components/indi_sidebar.dart';
import 'package:indi_tool/core/providers/test_case_provider.dart';
import 'package:indi_tool/features/home/presentation/clear_content_area.dart';
import 'package:indi_tool/features/home/presentation/test_data_view.dart';

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
      body: Row(children: [IndiSidebar(flex: 1), MainContentArea(flex: 4,)]),
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
    final selected = ref.watch(selectedTestCaseProvider);
    return Expanded(
      flex: widget.flex,
      child: selected == null
          ? const ClearContentArea()
          : TestDataView(test: selected),
    );
  }
}
