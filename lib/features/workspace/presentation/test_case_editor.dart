import 'package:flutter/material.dart';
import 'package:indi_tool/features/workspace/components/test_case_method_edit.dart';
import 'package:indi_tool/features/workspace/components/test_case_name_edit.dart';
import 'package:indi_tool/features/workspace/components/test_case_trigger.dart';
import 'package:indi_tool/features/workspace/components/test_case_url_edit.dart';
import 'package:indi_tool/features/workspace/presentation/test_case_tabs.dart';

class TestCaseEditor extends StatelessWidget {
  const TestCaseEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.edit_note_sharp),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TestCaseNameEdit(),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TestCaseMethodEdit(),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TestCaseUrlEdit(),
                ),
              ),
              SizedBox(width: 8),
              TestCaseTrigger(),
            ],
          ),
          Expanded(child: TestCaseTabs()),
        ],
      ),
    );
  }
}
