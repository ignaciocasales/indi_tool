import 'package:flutter/material.dart';
import 'package:indi_tool/ui/screens/home/quick_start_step.dart';

class QuickStartGuide extends StatelessWidget {
  const QuickStartGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(height: 0, color: Theme.of(context).colorScheme.primary),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Quick Start Guide',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        const QuickStartStep(
          title: '1. Create a Workspace',
          description: 'Begin by creating a workspace to organize your tests.',
        ),
        const QuickStartStep(
          title: '2. Configure a Test',
          description:
              'Set up your test parameters, including endpoints, load size, and duration.',
        ),
        const QuickStartStep(
          title: '3. Run the Test',
          description:
              'Execute the test and monitor its progress in real-time.',
        ),
        const QuickStartStep(
          title: '4. Analyze Results',
          description:
              'Review detailed reports to understand the performance and identify any issues.',
        ),
      ],
    );
  }
}
