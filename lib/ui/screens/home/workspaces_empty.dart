import 'package:flutter/material.dart';

class WorkspacesEmpty extends StatelessWidget {
  const WorkspacesEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            Icons.dashboard_customize_rounded,
            size: 80,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'No workspaces found.',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(4.0),
          child: Text('Create a new workspace to get started.'),
        )
      ],
    );
  }
}
