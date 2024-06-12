import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/app.dart';
import 'package:indi_tool/window.dart';

void main() {
  // Setup the initial window
  setupWindow();

  // Entry point of the app
  runApp(
    // Riverpod app state management
    const ProviderScope(
      // Main app widget
      child: IndiApp(),
    ),
  );
}
