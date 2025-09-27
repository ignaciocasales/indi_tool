import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/core/providers/test_case_provider.dart';

class TestCaseBodyEdit extends ConsumerStatefulWidget {
  const TestCaseBodyEdit({super.key});

  @override
  ConsumerState<TestCaseBodyEdit> createState() => _TestCaseBodyEditState();
}

class _TestCaseBodyEditState extends ConsumerState<TestCaseBodyEdit> {
  late TextEditingController _controller;
  bool _enabled = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_updateBody);
  }

  @override
  void dispose() {
    _controller.removeListener(_updateBody);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final testCase = ref.watch(selectedTestCaseProvider);
    if (testCase != null) {
      if (!_enabled) {
        setState(() {
          _enabled = true;
        });
      }

      final body = testCase.httpBody;
      if (_controller.text != body) {
        _controller.text = body;
      }
    } else {
      throw StateError('No scenario selected');
    }

    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Request Body',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: TextField(
                  key: Key('body-${testCase.id}'),
                  enabled: _enabled,
                  controller: _controller,
                  expands: true,
                  maxLines: null,
                  minLines: null,
                  textAlignVertical: TextAlignVertical.top,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontFamily: 'SourceCodePro'),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: "Enter request body (JSON, XML, etc.)",
                    hintStyle: theme.textTheme.bodySmall?.copyWith(
                      color: theme.hintColor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateBody() {
    final String body = _controller.text;

    final testCase = ref.watch(selectedTestCaseProvider);
    if (testCase == null) {
      return;
    }

    final updated = testCase.copyWith(httpBody: body);

    ref.read(testCaseListProvider.notifier).updateTestCase(updated);
  }
}
