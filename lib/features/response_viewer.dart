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
          // Top summary/header
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
                    // Method chip
                    Chip(
                      label: Text(testResult.requestMethod.toUpperCase()),
                      side: BorderSide(color: theme.colorScheme.primary),
                    ),
                    // Status chip
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
                    // Duration text
                    Text(
                      '${testResult.responseDurationInMillis}ms',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                // URL line
                Text(
                  testResult.requestUrl,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
          // Content sections (non-scrollable cards + headers area filling remaining space)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Response Metrics
                _SectionCard(
                  title: 'Response Metrics',
                  child: Row(
                    children: [
                      Expanded(
                        child: _MetricTile(
                          icon: Icons.timer_outlined,
                          label: 'Duration',
                          value: '${testResult.responseDurationInMillis}ms',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _MetricTile(
                          icon: Icons.data_usage,
                          label: 'Size',
                          value: '${testResult.responseBodySizeInBytes} B',
                        ),
                      ),
                    ],
                  ),
                ),
                // Timestamps
                _SectionCard(
                  title: 'Timestamps',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _TimestampRow(
                        icon: Icons.play_arrow_rounded,
                        label: 'Start',
                        value: testResult.responseStartDateTime,
                      ),
                      const SizedBox(height: 8),
                      _TimestampRow(
                        icon: Icons.stop_rounded,
                        label: 'End  ',
                        value: testResult.responseEndDateTime,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Response Headers (collapsible inside card, fills remaining space and scrolls internally)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: _HeadersCard(headers: testResult.responseHeaders),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 12.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: theme.dividerColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Text(
                    'Request ID',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.hintColor,
                    ),
                  ),
                  const Spacer(),
                  Flexible(
                    child: Text(
                      testResult.id,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
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

class _SectionCard extends StatelessWidget {
  const _SectionCard({this.title, required this.child});

  final String? title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) Text(title!, style: theme.textTheme.titleSmall),
          if (title != null) const SizedBox(height: 8.0),
          child,
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.hintColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(value, style: theme.textTheme.bodyMedium),
          ],
        ),
      ],
    );
  }
}

class _TimestampRow extends StatelessWidget {
  const _TimestampRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodySmall,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _HeadersCard extends StatefulWidget {
  const _HeadersCard({required this.headers});

  final Map<String, String> headers;

  @override
  State<_HeadersCard> createState() => _HeadersCardState();
}

class _HeadersCardState extends State<_HeadersCard> {
  late final ScrollController _headersScrollController;

  @override
  void initState() {
    super.initState();
    _headersScrollController = ScrollController();
  }

  @override
  void dispose() {
    _headersScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _SectionCard(
      child: Theme(
        data: Theme.of(
          context,
        ).copyWith(dividerColor: theme.dividerColor.withValues(alpha: 0.3)),
        child: ExpansionTile(
          initiallyExpanded: false,
          title: Row(
            children: [
              Text('Response Headers', style: theme.textTheme.titleSmall),
              const Spacer(),
              Text(
                'Tap to expand headers',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey),
              ),
              const Spacer(),
              Chip(label: Text('${widget.headers.length}')),
            ],
          ),
          dense: true,
          children: [
            SizedBox(
              height: 200, // or MediaQuery.of(context).size.height * 0.3
              child: Scrollbar(
                thumbVisibility: true,
                controller: _headersScrollController,
                radius: const Radius.circular(2),
                thickness: 4.0,
                child: ListView.separated(
                  controller: _headersScrollController,
                  itemCount: widget.headers.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    color: theme.dividerColor.withValues(alpha: 0.3),
                  ),
                  itemBuilder: (context, index) {
                    final entry = widget.headers.entries.elementAt(index);
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
                          Expanded(
                            child: Text(
                              entry.value,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontFamily: 'monospace',
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
