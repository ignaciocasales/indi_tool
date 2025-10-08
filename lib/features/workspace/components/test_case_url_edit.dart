import 'package:flutter/material.dart';
import 'package:indi_tool/core/domain/models/test_case.dart';

class TestCaseUrlEdit extends StatefulWidget {
  const TestCaseUrlEdit({
    super.key,
    required this.testCase,
    required this.onChanged,
  });

  final TestCase testCase;
  final void Function(TestCase updated) onChanged;

  @override
  State<TestCaseUrlEdit> createState() => _TestCaseUrlEditState();
}

class _TestCaseUrlEditState extends State<TestCaseUrlEdit> {
  late TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController();
    _urlController.text = widget.testCase.httpUrl;
    _urlController.addListener(_updateUrl);
  }

  @override
  void didUpdateWidget(covariant TestCaseUrlEdit oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newTc = widget.testCase;
    var oldTc = oldWidget.testCase;
    if (oldTc.httpUrl != newTc.httpUrl) {
      final previousSelection = _urlController.selection;
      _urlController.value = _urlController.value.copyWith(
        text: newTc.httpUrl,
        selection: previousSelection.isValid
            ? previousSelection
            : TextSelection.collapsed(offset: newTc.httpUrl.length),
      );
    }
  }

  @override
  void dispose() {
    _urlController.removeListener(_updateUrl);
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tc = widget.testCase;
    return TextFormField(
      key: Key('url-${tc.id}'),
      enabled: true,
      controller: _urlController,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: const InputDecoration(
        isDense: true,
        hintText: 'Enter request URL',
      ),
    );
  }

  void _updateUrl() {
    final tc = widget.testCase;
    final newUrl = _urlController.text;
    if (newUrl == tc.httpUrl) return;
    final updated = tc.copyWith(httpUrl: newUrl);
    widget.onChanged(updated);
  }
}
