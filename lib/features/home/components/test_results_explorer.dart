import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/core/application/global_state_provider.dart';
import 'package:indi_tool/core/application/load_runner_provider.dart';
import 'package:indi_tool/core/application/navigation_provider.dart';
import 'package:indi_tool/core/application/repositories/test_results_repository_provider.dart';
import 'package:indi_tool/core/application/result_buffer_provider.dart';

class TestResultsExplorer extends ConsumerStatefulWidget {
  const TestResultsExplorer({super.key});

  @override
  ConsumerState<TestResultsExplorer> createState() =>
      _TestResultsExplorerState();
}

class _TestResultsExplorerState extends ConsumerState<TestResultsExplorer> {
  @override
  Widget build(BuildContext context) {
    final isRunning = ref.watch(isLoadRunnerRunningStateProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: Row(
            children: [
              Text(
                'Test Results',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const Spacer(),
              Tooltip(
                message: 'Export to CSV',
                child: IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.file_download_outlined, size: 18),
                  onPressed: isRunning ? null : () async {},
                ),
              ),
              Tooltip(
                message: 'Clear results',
                child: IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.delete_sweep_outlined, size: 18),
                  onPressed: isRunning
                      ? null
                      : () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            barrierDismissible: false,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Confirm Deletion'),
                              content: const Text(
                                'Are you sure you want to clear all test results?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop(false);
                                  },
                                  child: const Text('Cancel'),
                                ),
                                FilledButton(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.error,
                                    foregroundColor: Theme.of(
                                      context,
                                    ).colorScheme.onError,
                                  ),
                                  onPressed: () {
                                    Navigator.of(ctx).pop(true);
                                  },
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );

                          if (confirmed == true) {
                            ref
                                .read(selectedTestResultIdProvider.notifier)
                                .clear();
                            var testPage = ref.read(selectedTestPageProvider);
                            if (testPage == TestCasePage.responseViewer) {
                              ref
                                  .read(selectedTestPageProvider.notifier)
                                  .select(TestCasePage.requestBuilder);
                            }
                            ref.read(resultBufferProvider).clear();
                          }
                        },
                ),
              ),
            ],
          ),
        ),
        const Expanded(child: TestResultList()),
      ],
    );
  }
}

class TestResultList extends ConsumerStatefulWidget {
  const TestResultList({super.key});

  @override
  ConsumerState<TestResultList> createState() => _TestResultListState();
}

class _TestResultListState extends ConsumerState<TestResultList> {
  @override
  Widget build(BuildContext context) {
    final isRunning = ref.watch(isLoadRunnerRunningStateProvider);
    final testCaseId = ref.watch(selectedTestCaseIdProvider);
    if (testCaseId == null) throw StateError('No test case selected');
    final allAsync = isRunning
        ? ref.watch(liveResultsProvider)
        : ref.watch(persistedResultsProvider(testCaseId));

    return allAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) =>
          const Center(child: Text('Failed to load test results')),
      data: (testsResults) {
        if (testsResults.isEmpty) {
          return const EmptyTestResultList();
        }
        return ListView.separated(
          padding: const EdgeInsets.all(12.0),
          itemCount: testsResults.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8.0),
          itemBuilder: (context, index) {
            final result = testsResults[index];
            final isSelected =
                result.id == ref.watch(selectedTestResultIdProvider);
            return InkWell(
              onTap: () => {
                ref.read(selectedTestResultIdProvider.notifier).set(result.id),
                ref
                    .read(selectedTestPageProvider.notifier)
                    .select(TestCasePage.responseViewer),
              },
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).dividerColor,
                    width: isSelected ? 1.2 : 1.0,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(children: [Text('${index + 1}.')]),
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 2.0,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).dividerColor,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            result.requestMethod,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8.0,
                              height: 8.0,
                              decoration: BoxDecoration(
                                color: result.isSuccessStatusCode
                                    ? Colors.green
                                    : Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              result.responseStatusCode.toString(),
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: Theme.of(context).hintColor,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.access_time, size: 14),
                                const SizedBox(width: 4.0),
                                Text(
                                  "${result.responseDurationInMillis.toStringAsFixed(0)}ms",
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
                                        color: Theme.of(context).hintColor,
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
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

class EmptyTestResultList extends StatelessWidget {
  const EmptyTestResultList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.public,
            size: 32,
            color: theme.hintColor.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 8),
          Text(
            'No test results yet',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Theme.of(context).hintColor,
            ),
          ),
        ],
      ),
    );
  }
}
