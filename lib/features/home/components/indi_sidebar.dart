import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/core/providers/test_case_provider.dart';
import 'package:indi_tool/features/home/components/back_to_main_btn.dart';
import 'package:indi_tool/features/home/components/test_cases_explorer.dart';
import 'package:indi_tool/features/home/components/test_results_explorer.dart';

class IndiSidebar extends StatelessWidget {
  const IndiSidebar({super.key, required this.flex});

  final int flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(color: Theme.of(context).dividerColor),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: IndiSideBarTopBar(),
                ),
              ],
            ),
            Expanded(child: IndiSidebarExplorer()),
          ],
        ),
      ),
    );
  }
}

class IndiSideBarTopBar extends ConsumerStatefulWidget {
  const IndiSideBarTopBar({super.key});

  @override
  ConsumerState<IndiSideBarTopBar> createState() => _IndiSideBarTopBarState();
}

class _IndiSideBarTopBarState extends ConsumerState<IndiSideBarTopBar> {
  @override
  Widget build(BuildContext context) {
    final testCaseId = ref.watch(selectedTestCaseIdProvider);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              if (testCaseId != null) BackToMainButton() else const SizedBox.shrink(),
              SizedBox(width: 20),
              Text(
                'Tests',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class IndiSidebarExplorer extends ConsumerStatefulWidget {
  const IndiSidebarExplorer({super.key});

  @override
  ConsumerState<IndiSidebarExplorer> createState() => _IndiSidebarExplorerState();
}

class _IndiSidebarExplorerState extends ConsumerState<IndiSidebarExplorer> {
  @override
  Widget build(BuildContext context) {
    final testCaseId = ref.watch(selectedTestCaseIdProvider);
    if (testCaseId != null) {
      return TestResultsExplorer();
    } else {
      return TestCasesExplorer();
    }
  }
}