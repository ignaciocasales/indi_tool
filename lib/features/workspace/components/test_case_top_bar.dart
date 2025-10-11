import 'package:flutter/material.dart';
import 'package:indi_tool/core/domain/models/test_case.dart';
import 'package:indi_tool/features/workspace/components/test_case_name_edit.dart';
import 'package:indi_tool/features/workspace/components/test_case_trigger.dart';

class TestCaseTopBar extends StatefulWidget {
  const TestCaseTopBar({
    super.key,
    required this.testCase,
    required this.onChanged,
  });

  final TestCase testCase;
  final void Function(TestCase updated) onChanged;

  @override
  State<TestCaseTopBar> createState() => _TestCaseTopBarState();
}

class _TestCaseTopBarState extends State<TestCaseTopBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Column(
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
                  child: TestCaseNameEdit(
                    testCase: widget.testCase,
                    onChanged: widget.onChanged,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const TestCaseTrigger(),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }
}
