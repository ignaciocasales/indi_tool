import 'package:flutter/material.dart';

import 'editor/editor_layout.dart';
import 'navigation/workspace_nav.dart';

class WorkspaceLayout extends StatelessWidget {
  const WorkspaceLayout({super.key});

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
