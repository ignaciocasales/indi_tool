import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/consts.dart';
import 'package:indi_tool/ui/navigation/app_router.dart';
import 'package:indi_tool/ui/scaffold.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScaffoldWrapper(
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
      body: Expanded(
        child: Column(
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
                  Text('v0.0.1'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
