import 'package:flutter/material.dart';
import 'package:indi_tool/ui/workspace/editor/cases/parameters/parameters_widget.dart';

class Params extends StatelessWidget {
  const Params({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ParametersWidget(),
      ],
    );
  }
}
