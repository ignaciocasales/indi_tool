import 'package:flutter/material.dart';
import 'package:indi_tool/core/domain/models/test_case.dart';
import 'package:indi_tool/features/workspace/components/test_case_method_edit.dart';
import 'package:indi_tool/features/workspace/components/test_case_url_edit.dart';
import 'package:indi_tool/features/workspace/presentation/test_case_tabs.dart';

class TestCaseEditor extends StatefulWidget {
  const TestCaseEditor({
    super.key,
    required this.testCase,
    required this.onChanged,
  });

  final TestCase testCase;
  final void Function(TestCase updated) onChanged;

  @override
  State<TestCaseEditor> createState() => _TestCaseEditorState();
}

class _TestCaseEditorState extends State<TestCaseEditor> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TestCaseMethodEdit(
                  testCase: widget.testCase,
                  onChanged: widget.onChanged,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TestCaseUrlEdit(
                    testCase: widget.testCase,
                    onChanged: widget.onChanged,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: TestCaseTabs(
              testCase: widget.testCase,
              onChanged: widget.onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
