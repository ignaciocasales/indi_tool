import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/core/domain/models/test_case.dart';
import 'package:indi_tool/core/providers/test_case_provider.dart';

class TestCaseUrlEdit extends ConsumerStatefulWidget {
  const TestCaseUrlEdit({super.key});

  @override
  ConsumerState<TestCaseUrlEdit> createState() => _TestCaseUrlEditState();
}

class _TestCaseUrlEditState extends ConsumerState<TestCaseUrlEdit> {
  late TextEditingController _urlController;
  bool _enabled = false;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController();
    _urlController.addListener(_updateUrl);
  }

  @override
  void dispose() {
    _urlController.removeListener(_updateUrl);
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TestCase? testCase = ref.watch(selectedTestCaseProvider);
    if (testCase != null) {
      if (!_enabled) {
        setState(() {
          _enabled = true;
        });
      }

      if (_urlController.text != testCase.httpUrl) {
        _urlController.text = testCase.httpUrl;
      }
    } else {
      throw StateError('No scenario selected');
    }

    return TextFormField(
      key: Key('url-${testCase.id}'),
      enabled: _enabled,
      controller: _urlController,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: const InputDecoration(
        isDense: true,
        hintText: 'Enter request URL',
      ),
    );
  }

  void _updateUrl() {
    final String url = _urlController.text;

    if (url.isEmpty) {
      return;
    }

    final testCase = ref.watch(selectedTestCaseProvider);

    if (testCase == null) {
      return;
    }

    final TestCase updated = testCase.copyWith(httpUrl: url);

    ref.read(testCaseListProvider.notifier).updateTestCase(updated);
  }
}
