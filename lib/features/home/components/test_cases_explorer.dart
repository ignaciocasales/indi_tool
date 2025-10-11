import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/core/application/global_state_provider.dart';
import 'package:indi_tool/core/application/navigation_provider.dart';
import 'package:indi_tool/core/application/repositories/test_cases_repository_provider.dart';
import 'package:indi_tool/core/domain/models/test_case.dart';

class TestCasesExplorer extends ConsumerStatefulWidget {
  const TestCasesExplorer({super.key});

  @override
  ConsumerState<TestCasesExplorer> createState() => _TestCasesExplorerState();
}

class _TestCasesExplorerState extends ConsumerState<TestCasesExplorer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                ref
                    .read(testCasesRepositoryProvider)
                    .insert(testCase: TestCase());
              },
              icon: const Icon(Icons.add),
              label: const Text('New Test'),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Expanded(child: TestCaseListWidget()),
      ],
    );
  }
}

class TestCaseListWidget extends ConsumerStatefulWidget {
  const TestCaseListWidget({super.key});

  @override
  ConsumerState<TestCaseListWidget> createState() => _TestCaseListWidgetState();
}

class _TestCaseListWidgetState extends ConsumerState<TestCaseListWidget> {
  @override
  Widget build(BuildContext context) {
    final allAsync = ref.watch(testCasesProvider);
    return allAsync.when(
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
                    .read(selectedTestCaseIdProvider.notifier)
                    .set(tests[index].id),
                ref
                    .read(selectedTestPageProvider.notifier)
                    .select(TestCasePage.requestBuilder),
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
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            tests[index].name,
                            style: Theme.of(context).textTheme.titleSmall,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        PopupMenuButton<String>(
                          tooltip: 'More',
                          icon: const Icon(Icons.more_vert),
                          onSelected: (value) async {
                            if (value == 'delete') {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                barrierDismissible: false,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Confirm Deletion'),
                                  content: Text(
                                    'Are you sure you want to delete the test "${tests[index].name}"?',
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
                                    .read(testCasesRepositoryProvider)
                                    .delete(id: tests[index].id);
                              }
                            }
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(
                              value: 'delete',
                              child: ListTile(
                                leading: Icon(Icons.delete_outline),
                                title: Text('Delete'),
                                dense: true,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      tests[index].httpUrl,
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
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
