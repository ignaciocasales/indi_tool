import 'package:flutter/material.dart';
import 'package:indi_tool/core/domain/models/test_case.dart';

class TestCaseNameEdit extends StatefulWidget {
  const TestCaseNameEdit({
    super.key,
    required this.testCase,
    required this.onChanged,
  });

  final TestCase testCase;
  final void Function(TestCase updated) onChanged;

  @override
  State<TestCaseNameEdit> createState() => _TestCaseNameEditState();
}

class _TestCaseNameEditState extends State<TestCaseNameEdit> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _nameController.text = widget.testCase.name;
    _nameController.addListener(_updateName);
  }

  @override
  void didUpdateWidget(covariant TestCaseNameEdit oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newTc = widget.testCase;
    var oldTc = oldWidget.testCase;
    if (oldTc.name != newTc.name) {
      final previousSelection = _nameController.selection;
      _nameController.value = _nameController.value.copyWith(
        text: newTc.name,
        selection: previousSelection.isValid
            ? previousSelection
            : TextSelection.collapsed(offset: newTc.name.length),
      );
    }
  }

  @override
  void dispose() {
    _nameController.removeListener(_updateName);
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tc = widget.testCase;
    return TextField(
      key: Key('name-${tc.id}'),
      enabled: true,
      controller: _nameController,
      style: Theme.of(context).textTheme.titleLarge,
      decoration: const InputDecoration(isDense: true),
    );
  }

  void _updateName() async {
    final tc = widget.testCase;
    final newName = _nameController.text;
    if (newName == tc.name) return;
    final updated = tc.copyWith(name: newName);
    widget.onChanged(updated);
  }
}
