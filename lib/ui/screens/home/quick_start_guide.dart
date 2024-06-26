import 'package:flutter/material.dart';
import 'package:indi_tool/ui/screens/home/quick_start_step.dart';

class QuickStartGuide extends StatelessWidget {
  const QuickStartGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Quick Start Guide',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 10),
        QuickStartStep(
          title: '1. Create a Workspace',
          description: 'Begin by creating a workspace to organize your tests.',
        ),
        QuickStartStep(
          title: '2. Configure a Test',
          description:
              'Set up your test parameters, including endpoints, load size, and duration.',
        ),
        QuickStartStep(
          title: '3. Run the Test',
          description:
              'Execute the test and monitor its progress in real-time.',
        ),
        QuickStartStep(
          title: '4. Analyze Results',
          description:
              'Review detailed reports to understand the performance and identify any issues.',
        ),
      ],
    );
  }
}
