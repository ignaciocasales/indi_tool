import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/core/providers/test_case_provider.dart';
import 'package:indi_tool/models/test_case.dart';

class TestCaseMethodEdit extends ConsumerStatefulWidget {
  const TestCaseMethodEdit({super.key});

  @override
  ConsumerState<TestCaseMethodEdit> createState() => _TestCaseMethodEditState();
}

class _TestCaseMethodEditState extends ConsumerState<TestCaseMethodEdit> {
  late final TextEditingController _controller;
  bool _enabled = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_updateMethod);
  }

  @override
  void dispose() {
    _controller.removeListener(_updateMethod);
    _controller.dispose();
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

      if (_controller.text != testCase.httpMethod) {
        _controller.text = testCase.httpMethod;
      }
    } else {
      throw StateError('No scenario selected');
    }

    return DropdownMenu(
      key: Key('http-method-${testCase.id}'),
      enabled: _enabled,
      controller: _controller,
      enableFilter: false,
      requestFocusOnTap: false,
      textAlign: TextAlign.center,
      dropdownMenuEntries: const [
        DropdownMenuEntry(value: 'GET', label: 'GET'),
        DropdownMenuEntry(value: 'POST', label: 'POST'),
        DropdownMenuEntry(value: 'PUT', label: 'PUT'),
        DropdownMenuEntry(value: 'DELETE', label: 'DELETE'),
        DropdownMenuEntry(value: 'PATCH', label: 'PATCH'),
      ],
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0)),
      ),
    );
  }

  void _updateMethod() {
    final String method = _controller.text;

    if (method.isEmpty) {
      return;
    }

    final TestCase? testCase = ref.watch(selectedTestCaseProvider);

    if (testCase == null) {
      return;
    }

    final TestCase updated = testCase.copyWith(httpMethod: method);

    ref.read(testCaseListProvider.notifier).updateTestCase(updated);
  }
}
