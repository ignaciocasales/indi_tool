import 'package:flutter/material.dart';

class SideNavigationLayout extends StatelessWidget {
  const SideNavigationLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      flex: 2,
      child: Column(
        children: [
          Text("Side Navigation Layout"),
        ],
      ),
    );
  }
}