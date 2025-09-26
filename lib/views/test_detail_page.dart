import 'package:flutter/material.dart';
import 'package:indi_tool/models/test_case.dart';

class TestDetailPage extends StatelessWidget {
  final TestCase test;
  const TestDetailPage({super.key, required this.test});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(test.name)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Detail page for ${test.name}', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(test.httpUrl),
          ],
        ),
      ),
    );
  }
}
