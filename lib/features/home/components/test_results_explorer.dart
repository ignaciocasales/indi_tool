import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/core/application/global_state_provider.dart';
import 'package:indi_tool/core/application/load_runner_provider.dart';
import 'package:indi_tool/core/application/navigation_provider.dart';
import 'package:indi_tool/core/application/repositories/test_results_repository_provider.dart';
import 'package:indi_tool/core/services/csv_exporter.dart';

class TestResultsExplorer extends ConsumerStatefulWidget {
  const TestResultsExplorer({super.key});

  @override
  ConsumerState<TestResultsExplorer> createState() =>
      _TestResultsExplorerState();
}

class _TestResultsExplorerState extends ConsumerState<TestResultsExplorer> {
  bool _showFilters = false;

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
                message: 'Filters',
                child: IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.filter_list, size: 18),
                  onPressed: () {
                    setState(() {
                      _showFilters = !_showFilters;
                    });
                  },
                ),
              ),
              Tooltip(
                message: 'Export to CSV',
                child: IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.file_download_outlined, size: 18),
                  onPressed: isRunning
                      ? null
                      : () async {
                          final testCaseId = ref.read(
                            selectedTestCaseIdProvider,
                          );
                          if (testCaseId == null) return;
                          final testResults = await ref.read(
                            persistedResultsProvider(testCaseId).future,
                          );
                          if (testResults.isEmpty) return;
                          export(results: testResults);
                        },
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
                            final testCaseId = ref.read(
                              selectedTestCaseIdProvider,
                            );
                            if (testCaseId == null) return;
                            ref
                                .read(selectedTestResultIdProvider.notifier)
                                .clear();
                            var testPage = ref.read(selectedTestPageProvider);
                            if (testPage == TestCasePage.responseViewer) {
                              ref
                                  .read(selectedTestPageProvider.notifier)
                                  .select(TestCasePage.requestBuilder);
                            }
                            ref
                                .read(testResultsRepositoryProvider)
                                .delete(testCaseId: testCaseId);
                          }
                        },
                ),
              ),
            ],
          ),
        ),
        if (_showFilters) const _TestResultsListFilter(),
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
    final allAsync = ref.watch(filteredTestResultsProvider);

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

class _TestResultsListFilter extends ConsumerStatefulWidget {
  const _TestResultsListFilter();

  @override
  ConsumerState<_TestResultsListFilter> createState() =>
      _TestResultsListFilterState();
}

class _TestResultsListFilterState
    extends ConsumerState<_TestResultsListFilter> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.filter_list),
                const SizedBox(width: 8, height: 32),
                Text('Filters', style: theme.textTheme.titleMedium),
                const Spacer(),
                Consumer(
                  builder: (context, ref, _) {
                    final filters = ref.watch(testResultsFiltersProvider);
                    if (!filters.anyActive) return const SizedBox.shrink();
                    return TextButton.icon(
                      onPressed: () =>
                          ref.read(testResultsFiltersProvider.notifier).clear(),
                      icon: const Icon(Icons.clear),
                      label: const Text('Clear Filters'),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('Search Content', style: theme.textTheme.labelMedium),
            const SizedBox(height: 6),
            Consumer(
              builder: (context, ref, _) {
                final filters = ref.watch(testResultsFiltersProvider);
                return TextField(
                  controller: TextEditingController(text: filters.query)
                    ..selection = TextSelection.fromPosition(
                      TextPosition(offset: filters.query.length),
                    ),
                  onChanged: (v) =>
                      ref.read(testResultsFiltersProvider.notifier).setQuery(v),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search text…',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Text('Result Type', style: theme.textTheme.labelMedium),
            const SizedBox(height: 6),
            Consumer(
              builder: (context, ref, _) {
                final filters = ref.watch(testResultsFiltersProvider);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _filterChip(
                        label: 'Success',
                        tooltip: 'Successful status codes (< 300)',
                        selected: filters.successOnly,
                        onSelected: (v) => ref
                            .read(testResultsFiltersProvider.notifier)
                            .setSuccessOnly(v),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _filterChip(
                        label: 'Failure',
                        tooltip: 'Failed status codes (>= 300)',
                        selected: filters.failureOnly,
                        onSelected: (v) => ref
                            .read(testResultsFiltersProvider.notifier)
                            .setFailureOnly(v),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            Text('Response Time (ms)', style: theme.textTheme.labelMedium),
            const SizedBox(height: 6),
            Consumer(
              builder: (context, ref, _) {
                final filters = ref.watch(testResultsFiltersProvider);
                return _MinMaxTestResultsListFilters(
                  filters: filters,
                  onChanged: (updated) => ref
                      .read(testResultsFiltersProvider.notifier)
                      .replace(updated),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip({
    required String label,
    required String tooltip,
    required bool selected,
    required void Function(bool) onSelected,
  }) {
    var theme = Theme.of(context);
    return FilterChip(
      label: Center(child: Text(label)),
      tooltip: tooltip,
      selected: selected,
      onSelected: onSelected,
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      selectedColor: theme.colorScheme.primaryContainer,
      side: BorderSide(
        color: selected ? theme.colorScheme.primary : theme.dividerColor,
      ),
    );
  }
}

class _MinMaxTestResultsListFilters extends StatefulWidget {
  const _MinMaxTestResultsListFilters({
    required this.filters,
    required this.onChanged,
  });

  final TestResultsFilters filters;
  final void Function(TestResultsFilters updated) onChanged;

  @override
  State<_MinMaxTestResultsListFilters> createState() =>
      _MinMaxTestResultsListFiltersState();
}

class _MinMaxTestResultsListFiltersState
    extends State<_MinMaxTestResultsListFilters> {
  late final TextEditingController _minMsController;
  late final TextEditingController _maxMsController;

  @override
  void initState() {
    super.initState();
    _minMsController = TextEditingController();
    _minMsController.text = widget.filters.minMs?.toString() ?? '';
    _minMsController.addListener(_updateMinMs);
    _maxMsController = TextEditingController();
    _maxMsController.text = widget.filters.maxMs?.toString() ?? '';
    _maxMsController.addListener(_updateMaxMs);
  }

  @override
  void didUpdateWidget(covariant _MinMaxTestResultsListFilters oldWidget) {
    super.didUpdateWidget(oldWidget);
    final filters = widget.filters;
    if (int.tryParse(_minMsController.text) != filters.minMs) {
      _minMsController.value = _minMsController.value.copyWith(
        text: filters.minMs?.toString() ?? '',
        selection: TextSelection.fromPosition(
          TextPosition(offset: (filters.minMs?.toString() ?? '').length),
        ),
      );
    }
    if (int.tryParse(_maxMsController.text) != filters.maxMs) {
      _maxMsController.value = _maxMsController.value.copyWith(
        text: filters.maxMs?.toString() ?? '',
        selection: TextSelection.fromPosition(
          TextPosition(offset: (filters.maxMs?.toString() ?? '').length),
        ),
      );
    }
  }

  @override
  void dispose() {
    _minMsController.removeListener(_updateMinMs);
    _minMsController.dispose();
    _maxMsController.removeListener(_updateMaxMs);
    _maxMsController.dispose();
    super.dispose();
  }

  void _updateMinMs() {
    final parsed = int.tryParse(_minMsController.text);
    final current = widget.filters.minMs;
    if (parsed == current) return;
    widget.onChanged(widget.filters.copyWith(minMs: parsed));
  }

  void _updateMaxMs() {
    final parsed = int.tryParse(_maxMsController.text);
    final current = widget.filters.maxMs;
    if (parsed == current) return;
    widget.onChanged(widget.filters.copyWith(maxMs: parsed));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _numberInput(controller: _minMsController, hintText: 'Min'),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _numberInput(controller: _maxMsController, hintText: 'Max'),
        ),
      ],
    );
  }

  Widget _numberInput({
    required final TextEditingController controller,
    required final String hintText,
  }) {
    const int minValue = 0;
    const int maxValue = 99999999999;
    return TextField(
      key: const Key('min-ms-input'),
      enabled: true,
      controller: controller,
      keyboardType: TextInputType.text,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        TextInputFormatter.withFunction((o, n) {
          if (n.text.isEmpty) {
            return n.copyWith(
              text: null, // clear the field
            );
          }

          // Prevent non-numeric input and leading zeros.
          final int? newValueInt = int.tryParse(n.text);
          if (newValueInt == null) {
            return n.copyWith(
              text: null, // clear the field
            );
          }

          // Enforce min constraints
          if (newValueInt < minValue) {
            return n.copyWith(
              text: minValue.toString(),
              selection: TextSelection.collapsed(
                offset: minValue.toString().length,
              ),
            );
          }

          // Enforce max constraints
          if (newValueInt > maxValue) {
            return n.copyWith(
              text: maxValue.toString(),
              selection: TextSelection.collapsed(
                offset: maxValue.toString().length,
              ),
            );
          }

          // Accept the new value
          return n.copyWith(
            text: newValueInt.toString(),
            selection: TextSelection.collapsed(
              offset: newValueInt.toString().length,
            ),
            composing: TextRange.empty,
          );
        }),
      ],
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
    );
  }
}
