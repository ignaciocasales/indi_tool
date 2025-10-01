import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/core/providers/navigation_provider.dart';

class TestNavigationButton extends ConsumerStatefulWidget {
  final String label;
  final TestCasePage testPage;

  const TestNavigationButton(this.label, this.testPage, {super.key});

  @override
  ConsumerState<TestNavigationButton> createState() =>
      _TestNavigationButtonState();
}

class _TestNavigationButtonState extends ConsumerState<TestNavigationButton> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final testPage = ref.watch(selectedTestPageProvider);

    final isSelected = testPage == widget.testPage;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: SizedBox(
        width: double.infinity,
        child: TextButton(
          onPressed: () => {
            ref
                .watch(selectedTestPageProvider.notifier)
                .select(widget.testPage),
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            alignment: Alignment.centerLeft,
            backgroundColor: isSelected
                ? theme.colorScheme.onSurface.withValues(alpha: 0.3)
                : theme.colorScheme.onSurface.withValues(alpha: 0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            widget.label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}
