import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/models/navigation/indi_route.dart';
import 'package:indi_tool/providers/navigation/app_router_prov.dart';
import 'package:indi_tool/ui/screens/home/home_screen.dart';
import 'package:indi_tool/ui/screens/settings_screen.dart';
import 'package:indi_tool/ui/workspace/workspace_layout.dart';

class AppRouter extends ConsumerWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final IndiRoute route = ref.watch(selectedRouteProvider);

    final Widget widget = switch (route) {
      IndiRoute.home => const HomeScreen(),
      IndiRoute.workspace => const WorkspaceLayout(),
      IndiRoute.settings => const SettingsScreen()
    };

    return widget;
  }
}
