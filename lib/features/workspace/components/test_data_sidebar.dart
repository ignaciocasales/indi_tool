import 'package:flutter/material.dart';
import 'package:indi_tool/core/providers/navigation_provider.dart';
import 'package:indi_tool/features/workspace/components/test_navigation_button.dart';

class TestDataSideBar extends StatelessWidget {
  const TestDataSideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Theme.of(context).dividerColor),
                    ),
                  ),
                  child: Text(
                    "Views",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: const [
                      TestNavigationButton(
                        'Request Builder',
                        TestCasePage.requestBuilder,
                      ),
                      TestNavigationButton(
                        'Performance Metrics',
                        TestCasePage.metricsExplorer,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
