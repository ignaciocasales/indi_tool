import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/core/domain/models/test_case.dart';
import 'package:indi_tool/core/providers/test_case_provider.dart';

class ClearContentArea extends ConsumerWidget {
  const ClearContentArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Load Testing Dashboard',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Create a new test or select an existing one to get started',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Create a new test case.
              ref.read(testCaseListProvider.notifier).add(TestCase());
            },
            child: const Text('Create New Test'),
          ),
        ],
      ),
    );
  }
}
