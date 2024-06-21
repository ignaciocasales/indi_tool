import 'package:flutter/material.dart';

import 'editor/editor_layout.dart';
import 'navigation/workspace_nav.dart';

class Workspace extends StatelessWidget {
  const Workspace({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Row(children: [
        WorkspaceNav(),
        VerticalDivider(width: 0),
        EditorLayout(),
      ]),
    );
  }
}
