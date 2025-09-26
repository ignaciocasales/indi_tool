import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/core/providers/test_case_provider.dart';
import 'package:indi_tool/features/home/components/test_case_list.dart';
import 'package:indi_tool/models/test_case.dart';

class IndiSidebar extends ConsumerStatefulWidget {
  const IndiSidebar({super.key, required this.flex});

  final int flex;

  @override
  ConsumerState<IndiSidebar> createState() => _IndiSidebarState();
}

class _IndiSidebarState extends ConsumerState<IndiSidebar> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: widget.flex,
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
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            BackToMainButton(),
                            SizedBox(width: 20),
                            Text(
                              'Tests',
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).textTheme.bodySmall?.color,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ref.watch(testCaseListProvider.notifier).add(TestCase());
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('New Test'),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Expanded(child: TestCaseListWidget()),
          ],
        ),
      ),
    );
  }
}

class BackToMainButton extends ConsumerStatefulWidget {
  const BackToMainButton({super.key});

  @override
  ConsumerState<BackToMainButton> createState() => _BackToMainButtonState();
}

class _BackToMainButtonState extends ConsumerState<BackToMainButton> {
  @override
  Widget build(BuildContext context) {
    final testCase = ref.watch(selectedTestCaseProvider);

    if (testCase == null) {
      return const SizedBox.shrink();
    }

    return IconButton(
      onPressed: () {
        ref.watch(selectedTestCaseIdProvider.notifier).clear();
      },
      icon: Icon(
        Icons.arrow_back,
        size: 16,
        color: Theme.of(context).iconTheme.color,
      ),
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(minWidth: 16, minHeight: 16),
      splashRadius: 16,
    );
  }
}
