import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/core/application/global_state_provider.dart';
import 'package:indi_tool/core/application/repositories/test_cases_repository_provider.dart';
import 'package:indi_tool/core/domain/models/test_case.dart';
import 'package:indi_tool/features/workspace/components/test_case_method_edit.dart';
import 'package:indi_tool/features/workspace/components/test_case_name_edit.dart';
import 'package:indi_tool/features/workspace/components/test_case_trigger.dart';
import 'package:indi_tool/features/workspace/components/test_case_url_edit.dart';
import 'package:indi_tool/features/workspace/presentation/test_case_tabs.dart';

class TestCaseEditor extends ConsumerStatefulWidget {
  const TestCaseEditor({super.key});

  @override
  ConsumerState<TestCaseEditor> createState() => _TestCaseEditorState();
}

class _TestCaseEditorState extends ConsumerState<TestCaseEditor> {
  @override
  Widget build(BuildContext context) {
    final tcAsync = ref.watch(selectedTestCaseProvider);
    final isReady = tcAsync.hasValue && tcAsync.value != null;
    if (!isReady) {
      return const Center(child: CircularProgressIndicator()); // FIXME?
    }
    final tc = tcAsync.value!;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.edit_note_sharp),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TestCaseNameEdit(testCase: tc, onChanged: _onChanged),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TestCaseMethodEdit(testCase: tc, onChanged: _onChanged),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TestCaseUrlEdit(testCase: tc, onChanged: _onChanged),
                ),
              ),
              const SizedBox(width: 8),
              const TestCaseTrigger(),
            ],
          ),
          Expanded(
            child: TestCaseTabs(testCase: tc, onChanged: _onChanged),
          ),
        ],
      ),
    );
  }

  void _onChanged(TestCase updated) {
    ref.read(testCasesRepositoryProvider).update(testCase: updated);
  }
}
