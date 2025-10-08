import 'package:flutter/material.dart';
import 'package:indi_tool/core/domain/models/test_case.dart';
import 'package:indi_tool/features/workspace/components/test_case_body_edit.dart';
import 'package:indi_tool/features/workspace/components/test_case_configuration_edit.dart';
import 'package:indi_tool/features/workspace/components/test_case_headers_edit.dart';

class TestCaseTabs extends StatefulWidget {
  const TestCaseTabs({
    super.key,
    required this.testCase,
    required this.onChanged,
  });

  final TestCase testCase;
  final void Function(TestCase updated) onChanged;

  @override
  State<TestCaseTabs> createState() => _TestCaseTabsState();
}

class _TestCaseTabsState extends State<TestCaseTabs>
    with TickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _controller,
          tabs: const [
            Tab(text: 'Headers'),
            Tab(text: 'Body'),
            Tab(text: 'Configuration'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _controller,
            children: [
              TestCaseHeadersEdit(
                testCase: widget.testCase,
                onChanged: widget.onChanged,
              ),
              TestCaseBodyEdit(
                testCase: widget.testCase,
                onChanged: widget.onChanged,
              ),
              TestCaseConfigurationEdit(
                testCase: widget.testCase,
                onChanged: widget.onChanged,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
