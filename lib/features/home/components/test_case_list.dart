import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/core/providers/test_case_provider.dart';

class TestCaseListWidget extends ConsumerStatefulWidget {
  const TestCaseListWidget({super.key});

  @override
  ConsumerState<TestCaseListWidget> createState() => _TestCaseListState();
}

class _TestCaseListState extends ConsumerState<TestCaseListWidget> {
  @override
  Widget build(BuildContext context) {
    final testsAsync = ref.watch(testCaseListProvider);
    return testsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => const Center(child: Text('Failed to load tests')),
      data: (tests) {
        if (tests.isEmpty) {
          return const Center(child: Text('No tests yet'));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: tests.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () => {
                ref
                    .watch(selectedTestCaseIdProvider.notifier)
                    .set(tests[index].id),
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                          ),
                          child: Text(
                            tests[index].httpMethod,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            '0 results',
                            style: Theme.of(context).textTheme.labelSmall,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      tests[index].name,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      tests[index].httpUrl,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
