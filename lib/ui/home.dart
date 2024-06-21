import 'package:flutter/material.dart';
import 'package:indi_tool/consts.dart';
import 'package:indi_tool/ui/navigation/app_router.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          kShortAppName,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          const Expanded(
            child: Row(
              children: [
                AppRouter(),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // TODO: Add real version number.
                Text('v1.0.0'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
