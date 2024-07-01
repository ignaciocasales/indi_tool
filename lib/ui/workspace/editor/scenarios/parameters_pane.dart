import 'package:flutter/material.dart';
import 'package:indi_tool/ui/workspace/editor/scenarios/editor/parameters.dart';

class Parameters extends StatelessWidget {
  const Parameters({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ParametersWidget(),
      ],
    );
  }
}
