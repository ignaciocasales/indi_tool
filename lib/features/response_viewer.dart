import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/core/application/global_state_provider.dart';

class TestCaseResponseViewer extends ConsumerStatefulWidget {
  const TestCaseResponseViewer({super.key});

  @override
  ConsumerState<TestCaseResponseViewer> createState() =>
      _TestCaseResponseViewerState();
}

class _TestCaseResponseViewerState
    extends ConsumerState<TestCaseResponseViewer> {
  @override
  Widget build(BuildContext context) {
    final testResultAsync = ref.watch(selectedTestResultProvider);
    final isReady = testResultAsync.hasValue && testResultAsync.value != null;
    if (!isReady) {
      return const Expanded(
        child: Center(
          child: Text('No response available'), // FIXME: better placeholder?
        ),
      );
    }
    final testResult = testResultAsync.value!;

    final theme = Theme.of(context);

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: theme.dividerColor)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 12.0,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Icon(
                      testResult.isSuccessStatusCode
                          ? Icons.check_circle
                          : Icons.error,
                      color: testResult.isSuccessStatusCode
                          ? Colors.green
                          : Colors.red,
                    ),
                    Chip(
                      label: Text(
                        '${testResult.responseStatusCode}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: testResult.isSuccessStatusCode
                          ? Colors.green
                          : Colors.red,
                    ),
                    Text(
                      '${testResult.responseDurationInMillis}ms',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Request URL: ${testResult.requestUrl}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Response Body
                  ExpansionTile(
                    initiallyExpanded: false,
                    title: Text(
                      'Response Body',
                      style: theme.textTheme.titleSmall,
                    ),
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12.0),
                        color: theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.05,
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            'There are no response bodies anymore', // FIXME
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Response Headers
                  ExpansionTile(
                    initiallyExpanded: false,
                    title: Text(
                      'Response Headers',
                      style: theme.textTheme.titleSmall,
                    ),
                    children: testResult.responseHeaders.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 13.0,
                          vertical: 4.0,
                        ),
                        child: Row(
                          children: [
                            Text(
                              '${entry.key}:',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'monospace',
                                color: theme.hintColor,
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              entry.value,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
