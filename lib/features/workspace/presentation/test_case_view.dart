import 'package:flutter/material.dart';
import 'package:indi_tool/features/workspace/components/test_data_sidebar.dart';
import 'package:indi_tool/features/workspace/presentation/test_data_content_area.dart';

class TestCaseView extends StatelessWidget {
  const TestCaseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(children: [TestDataSideBar(), TestCaseContentArea()]);
  }
}
