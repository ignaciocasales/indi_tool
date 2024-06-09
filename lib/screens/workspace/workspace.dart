import 'package:flutter/material.dart';

import 'editor/simple_request_editor_layout.dart';
import 'navigation/side_navigation_layout.dart';

class Workspace extends StatelessWidget {
  const Workspace({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Row(children: [
        SideNavigationLayout(),
        VerticalDivider(),
        SimpleRequestEditorLayout(),
      ]),
    );
  }
}
