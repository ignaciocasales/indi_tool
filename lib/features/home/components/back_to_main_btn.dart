import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/core/application/global_state_provider.dart';
import 'package:indi_tool/core/application/navigation_provider.dart';

class BackToMainButton extends ConsumerStatefulWidget {
  const BackToMainButton({super.key});

  @override
  ConsumerState<BackToMainButton> createState() => _BackToMainButtonState();
}

class _BackToMainButtonState extends ConsumerState<BackToMainButton> {
  @override
  Widget build(BuildContext context) {
    final testCaseId = ref.watch(selectedTestCaseIdProvider);

    if (testCaseId == null) throw StateError('No scenario selected');

    return IconButton(
      onPressed: () => {
        ref.read(selectedTestCaseIdProvider.notifier).clear(),
        ref.read(selectedTestPageProvider.notifier).clear(),
      },
      icon: Icon(
        Icons.arrow_back,
        size: 16,
        color: Theme.of(context).iconTheme.color,
      ),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
      splashRadius: 16,
    );
  }
}
