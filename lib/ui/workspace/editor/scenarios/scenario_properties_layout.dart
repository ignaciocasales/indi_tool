import 'package:flutter/material.dart';
import 'package:indi_tool/ui/workspace/editor/scenarios/editor/description.dart';
import 'package:indi_tool/ui/workspace/editor/scenarios/editor/iterations.dart';
import 'package:indi_tool/ui/workspace/editor/scenarios/editor/threads.dart';
import 'package:indi_tool/ui/workspace/editor/scenarios/editor/timeout.dart';

class ScenarioPropertiesLayout extends StatelessWidget {
  const ScenarioPropertiesLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Properties',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            children: [
              IterationsEditingWidget(),
              ThreadsEditingWidget(),
            ],
          ),
          Row(
            children: [
              TimeoutEditingWidget(),
              Expanded(flex: 5, child: SizedBox()),
            ],
          ),
          Expanded(
            child: Row(
              children: [
                DescriptionEditingWidget(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
