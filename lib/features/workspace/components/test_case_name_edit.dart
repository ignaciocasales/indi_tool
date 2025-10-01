import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/core/providers/test_case_provider.dart';
import 'package:indi_tool/models/test_case.dart';

class TestCaseNameEdit extends ConsumerStatefulWidget {
  const TestCaseNameEdit({super.key});

  @override
  ConsumerState<TestCaseNameEdit> createState() => _TestCaseNameEditState();
}

class _TestCaseNameEditState extends ConsumerState<TestCaseNameEdit> {
  late TextEditingController _nameController;
  bool _enabled = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _nameController.addListener(_updateName);
  }

  @override
  void dispose() {
    _nameController.removeListener(_updateName);
    _nameController.dispose();
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

      if (_nameController.text != testCase.name) {
        _nameController.text = testCase.name;
      }
    } else {
      throw StateError('No scenario selected');
    }

    return TextField(
      key: Key('name-${testCase.id}'),
      enabled: _enabled,
      controller: _nameController,
      style: Theme.of(context).textTheme.titleLarge,
      decoration: const InputDecoration(isDense: true),
    );
  }

  void _updateName() async {
    final String name = _nameController.text;

    if (name.isEmpty) {
      return;
    }

    final TestCase? testCase = ref.watch(selectedTestCaseProvider);

    if (testCase == null) {
      return;
    }

    final TestCase updated = testCase.copyWith(name: name);

    ref.read(testCaseListProvider.notifier).updateTestCase(updated);
  }
}
