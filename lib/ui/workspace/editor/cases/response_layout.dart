import 'package:flutter/material.dart';

class ResponseLayout extends StatelessWidget {
  const ResponseLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.secondary;
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.rocket_launch_rounded,
                  size: 80,
                  color: color,
                ),
                const Text('Hit Start to begin'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
