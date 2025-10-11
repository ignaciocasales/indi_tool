import 'package:flutter/material.dart';
import 'package:indi_tool/core/domain/models/test_case.dart';

class TestCaseMethodEdit extends StatefulWidget {
  const TestCaseMethodEdit({
    super.key,
    required this.testCase,
    required this.onChanged,
  });

  final TestCase testCase;
  final void Function(TestCase updated) onChanged;

  @override
  State<TestCaseMethodEdit> createState() => _TestCaseMethodEditState();
}

class _TestCaseMethodEditState extends State<TestCaseMethodEdit> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.text = widget.testCase.httpMethod;
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
    final tc = widget.testCase;
    return DropdownMenu(
      key: Key('http-method-${tc.id}'),
      enabled: true,
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
    final tc = widget.testCase;
    final newMethod = _controller.text;
    if (newMethod.isEmpty || newMethod == tc.httpMethod) return;
    final updated = tc.copyWith(httpMethod: newMethod);
    widget.onChanged(updated);
  }
}
