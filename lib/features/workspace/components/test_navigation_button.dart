import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/core/application/global_state_provider.dart';
import 'package:indi_tool/core/application/navigation_provider.dart';

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
            ref.read(selectedTestResultIdProvider.notifier).clear(),
            ref.read(selectedTestPageProvider.notifier).select(widget.testPage),
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            alignment: Alignment.centerLeft,
            backgroundColor: isSelected
                ? theme.colorScheme.primaryContainer
                : theme.colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.dividerColor,
                width: isSelected ? 1.2 : 1,
              ),
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
