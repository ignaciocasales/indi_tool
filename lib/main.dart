import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/app.dart';
import 'package:indi_tool/consts.dart';
import 'package:indi_tool/core/compression/zstd.dart';
import 'package:indi_tool/data/source/database.dart';
import 'package:indi_tool/window.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup the initial window
  setupWindow();

  // Setup the Zstd library
  Zstd.setup();

  // Setup the database
  DriftDbInstance.setup(
    dbName: kDatabaseName,
    inMemory: false,
    logStatements: false,
  );

  // Entry point of the app
  runApp(
    // Riverpod app state management
    const ProviderScope(
      // Main app widget
      child: IndiApp(),
    ),
  );
}
